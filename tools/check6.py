"""Checagens da v6: interferências (todas as peças, em repouso) e varredura dos giros.
uso (na raiz do repositório): bash tools/build6.sh asm_ topo berco tampa cabo chave porca trava_ponte garfo trava bincl braco garra brol mordente bmord trava_celular
     python3 tools/check6.py [rapido]"""
import trimesh, numpy as np, math, re, sys, itertools
from trimesh.creation import box
from trimesh.transformations import rotation_matrix as RM

SC = open('scad/camcorder_rig_v6.scad').read()
def P(n): return float(eval(re.search(r'(?<![A-Za-z_])' + n + r'\s*=\s*([^;/]+);', SC).group(1), {}, {}))
L = lambda f: trimesh.load(f, force='mesh')
cam = L('ref/sanyo_vcc4344_mm.stl'); cam.apply_translation([0, 0, -40.15])
FIX = ['topo', 'berco', 'tampa', 'cabo', 'chave', 'porca', 'trava_ponte']
PAN = ['garfo', 'trava', 'bincl']; TILT = ['braco']; ROLL = ['garra', 'mordente', 'brol', 'bmord', 'trava_celular']
Pm = {k: L(f'build/asm6/{k}.stl') for k in FIX + PAN + TILT + ROLL}
PC = P('PC'); ZP = 27 + 3 + 4; ZT = ZP + 5 + 17; ZR = ZT + P('ARM_LEN')
GYB = PC + 4 + P('BOSS_T') + 0.05; YC = GYB + 5 + 0.25 + 3 + 1 + 6
TRV = 0.15 + 1.6*math.sqrt(2)          # a calha da trava lateral levanta o celular
OPEN = 71.2 + 7.9; ZVB = ZR - OPEN/2
PB_Y0 = -63.25 + 33 + 0.4
def rbox(ext, center, r):        # caixa com arestas verticais arredondadas
    parts = []
    for sx, sy in itertools.product([-1, 1], [-1, 1]):
        c = trimesh.creation.cylinder(radius=r, height=ext[2], sections=32); c.apply_translation([sx*(ext[0]/2 - r), sy*(ext[1]/2 - r), 0]); parts.append(c)
    h = trimesh.util.concatenate(parts).convex_hull; h.apply_translation(center); return h
pb = rbox([67, 124, 13], [0, PB_Y0 + 62, -27 - 6.5], 4)
ECs = [P('EC_A'), P('EC_B'), P('EC_C')]; ECY0 = P('EC_Y0')
ECX0 = 33.9 + 2 + 20 - ECs[2] - 0.5; ECZ0 = -42.4
ec = box([ECs[2], ECs[0], ECs[1]]); ec.apply_translation([ECX0 + ECs[2]/2, ECY0 + ECs[0]/2, ECZ0 + ECs[1]/2])
ph = box([151.7, 7.9, 71.2]); ph.apply_translation([0, YC, ZVB + TRV + 3.95 + 35.6])

def iv(a, b):
    if not (np.all(a.bounds[0] < b.bounds[1]) and np.all(b.bounds[0] < a.bounds[1])): return 0.0
    i = trimesh.boolean.intersection([a, b], engine='manifold')
    return 0.0 if i is None or i.is_empty else float(i.volume)
def pose(pan, tilt, roll):
    Rp = RM(math.radians(pan), [0, 0, 1], [0, PC, 0]); Rt = RM(math.radians(tilt), [1, 0, 0], [0, PC, ZT]); Rr = RM(math.radians(roll), [0, 1, 0], [0, 0, ZR])
    o = {}
    for k in PAN: o[k] = Pm[k].copy(); o[k].apply_transform(Rp)
    for k in TILT: o[k] = Pm[k].copy(); o[k].apply_transform(Rp @ Rt)
    for k in ROLL: o[k] = Pm[k].copy(); o[k].apply_transform(Rp @ Rt @ Rr)
    o['celular'] = ph.copy(); o['celular'].apply_transform(Rp @ Rt @ Rr)
    return o
fixed = {'camera': cam, 'pb': pb, 'ec': ec, **{k: Pm[k] for k in FIX}}
ok_pairs = {('celular', 'garra'), ('celular', 'mordente'), ('celular', 'trava_celular')}       # as mandíbulas encostam no celular de propósito
MOV = PAN + TILT + ROLL + ['celular']
def grp(k): return 0 if k in PAN else 1 if k in TILT else 2
def hits(pan, tilt, roll, thr=0.3):
    o = pose(pan, tilt, roll); bad = []
    for mk in MOV:
        for fk, fm in fixed.items():
            if (mk, fk) in ok_pairs: continue
            v = iv(o[mk], fm)
            if v > thr: bad.append(f'{mk}x{fk}:{v:.1f}')
    for i, a in enumerate(MOV):
        for b in MOV[i+1:]:
            if (a, b) in ok_pairs or (b, a) in ok_pairs: continue
            v = iv(o[a], o[b])
            if v > thr: bad.append(f'{a}x{b}:{v:.1f}')
    return bad

print('== repouso, todos os pares (mm3 > 0,02):')
allm = {**fixed, **pose(0, 0, 0)}
ks = list(allm)
for i, a in enumerate(ks):
    for b in ks[i+1:]:
        if (a, b) in ok_pairs or (b, a) in ok_pairs or {a, b} <= {'camera', 'pb', 'ec'}: continue
        v = iv(allm[a], allm[b])
        if v > 0.02: print(f'   {a} x {b}: {v:.2f}')
print(f'   (berco x pb: molas com pré-carga, esperado ~{4*5*7*1.3*0.6:.0f})')
if len(sys.argv) > 1: sys.exit()
print('== giros (celular S21):')
for sgn, name in [(1, 'tilt +'), (-1, 'tilt -')]:
    last = 0
    for t in range(5, 100, 5):
        h = hits(0, sgn*t, 0)
        if h: print(f'   {name}{t}: {h}'); break
        last = t
    print(f'   {name} livre até {last}°')
last = 0
for r in range(5, 95, 5):
    h = hits(0, 0, r) or hits(0, 0, -r)
    if h: print(f'   roll {r}: {h}'); break
    last = r
print(f'   roll livre até ±{last}°')
bad = [p for p in range(0, 360, 30) if hits(p, 0, 0)]
print('   pan: bate em', bad or 'nada (360° livre)')
bad = [p for p in range(0, 360, 45) if hits(p, 60, 0)]
print('   pan com tilt +60:', bad or 'livre')
for t, r in [(95, 35), (95, -35), (-35, 35), (-35, -35), (90, 0), (-30, 0)]:
    h = hits(0, t, r); print(f'   tilt {t} roll {r}:', h or 'ok')
