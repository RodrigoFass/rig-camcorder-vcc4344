"""Checagens do suporte fixo (clip do MakerWorld): interferências em repouso e folgas do pé no pino.
uso (na raiz do repositório):
     python3 tools/clip_perfil.py ClipV3.3mf
     bash tools/build6.sh asm_ topo berco tampa cabo chave trava_ponte clip porca_clip celular_clip
     python3 tools/check_clip.py"""
import trimesh, numpy as np, re, itertools
from trimesh.creation import box

SC = open('scad/camcorder_rig_v6.scad').read()
L = lambda f: trimesh.load(f, force='mesh')
cam = L('ref/sanyo_vcc4344_mm.stl'); cam.apply_translation([0, 0, -40.15])
FIX = ['topo', 'berco', 'tampa', 'cabo', 'chave', 'trava_ponte', 'clip', 'porca_clip', 'celular_clip']
Pm = {k: L(f'build/asm6/{k}.stl') for k in FIX}
PB_Y0 = -63.25 + 33 + 0.4
def rbox(ext, center, r):
    parts = []
    for sx, sy in itertools.product([-1, 1], [-1, 1]):
        c = trimesh.creation.cylinder(radius=r, height=ext[2], sections=32); c.apply_translation([sx*(ext[0]/2 - r), sy*(ext[1]/2 - r), 0]); parts.append(c)
    h = trimesh.util.concatenate(parts).convex_hull; h.apply_translation(center); return h
pb = rbox([67, 124, 13], [0, PB_Y0 + 62, -27 - 6.5], 4)
def iv(a, b):
    if not (np.all(a.bounds[0] < b.bounds[1]) and np.all(b.bounds[0] < a.bounds[1])): return 0.0
    i = trimesh.boolean.intersection([a, b], engine='manifold')
    return 0.0 if i is None or i.is_empty else float(i.volume)
allm = {'camera': cam, 'pb': pb, **Pm}
ok = {('clip', 'celular_clip')}          # o celular encosta nos dentes de propósito
print('== repouso, todos os pares (mm3 > 0,02):')
ks = list(allm)
for i, a in enumerate(ks):
    for b in ks[i+1:]:
        if (a, b) in ok or (b, a) in ok or {a, b} <= {'camera', 'pb'}: continue
        v = iv(allm[a], allm[b])
        if v > 0.02: print(f'   {a} x {b}: {v:.2f}')
print('   (berco x pb: molas com pré-carga, esperado ~73)')

# folgas mínimas (distância entre superfícies) nos pontos críticos
def gap(a, b, n=40000, lim=15):           # menor distância entre as superfícies (sem interferência)
    pts = a.sample(n)
    lo, hi = b.bounds[0] - lim, b.bounds[1] + lim
    pts = pts[np.all((pts > lo) & (pts < hi), axis=1)]
    if len(pts) == 0: return float('inf')
    pq = trimesh.proximity.ProximityQuery(b)
    return float(min(pq.on_surface(c)[1].min() for c in np.array_split(pts, max(1, len(pts)//1500))))
cl, top, pc = Pm['clip'], Pm['topo'], Pm['porca_clip']
print('== folgas:')
print(f'   clip → câmera: {gap(cl, cam):.2f} mm')
print(f'   clip → trava da ponte: {gap(cl, Pm["trava_ponte"]):.2f} mm')
print(f'   porca-botão → clip: {gap(pc, cl):.2f} mm')
print(f'   celular → porca-botão: {gap(Pm["celular_clip"], pc):.2f} mm')
# assento do pé: o fundo do pé encosta no topo da base do giro (Z_PAN = 34)
b = cl.bounds; print(f'   pé do clip: Z {b[0][2]:.2f}..{b[1][2]:.2f}, Y {b[0][1]:.1f}..{b[1][1]:.1f}, X {b[0][0]:.2f}..{b[1][0]:.2f}')
c = Pm['celular_clip'].bounds; print(f'   celular: Y {c[0][1]:.1f}..{c[1][1]:.1f}, Z {c[0][2]:.1f}..{c[1][2]:.1f}')
