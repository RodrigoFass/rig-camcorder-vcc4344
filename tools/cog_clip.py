"""Centro de massa do rig v6 com o suporte fixo (clip), posição da mão e estabilidade em pé.
uso (na raiz): bash tools/build6.sh asm_ topo berco tampa cabo chave trava_ponte clip porca_clip celular_clip
     python3 tools/cog_clip.py"""
import trimesh, numpy as np, re, sys, math, glob, os
from trimesh.transformations import rotation_matrix as RM

SC = open('scad/camcorder_rig_v6.scad').read()
def P(n): return float(eval(re.search(r'(?<![A-Za-z_])' + n + r'\s*=\s*([^;/]+);', SC).group(1), {'tan': lambda d: math.tan(math.radians(d))}, {}))
L = lambda f: trimesh.load(f, force='mesh')
PC = P('PC'); ZP = 27 + 3 + 4; ZT = ZP + 5 + 17; ZR = ZT + P('ARM_LEN')
PB_Y0 = -63.25 + 33 + 0.4
# fração cheia estimada (3 perímetros, 15 % de preenchimento; paredes finas saem maciças)
FILL = {'clip': 0.55, 'porca_clip': 0.9, 'topo': 0.6, 'tampa': 0.95, 'berco': 0.9, 'cabo': 0.32, 'chave': 1.0, 'porca': 0.95, 'trava': 0.9, 'bincl': 0.8, 'brol': 0.75, 'bmord': 0.9, 'trava_ponte': 0.9, 'trava_celular': 0.75,
        'garfo': 0.6, 'braco': 0.6, 'garra': 0.55, 'mordente': 0.6}
items = []
for k in ['topo', 'berco', 'tampa', 'cabo', 'chave', 'trava_ponte', 'clip', 'porca_clip']:
    m = L(f'build/asm6/{k}.stl')
    items.append((k, m.volume/1000*1.27*FILL.get(k, 0.6), m.center_mass))
cel = L('build/asm6/celular_clip.stl')
items += [('câmera (corpo)', 430, np.array([0, 0, 0])), ('lente CS', 60, np.array([0, -78, 0])), ('ferro', 25, np.array([0, -43, -33])),
          ('power bank', 220, np.array([0, PB_Y0 + 62, -33.5])), ('EasyCap + adaptador OTG', 45, np.array([47.65, P('EC_Y0') + 25, -29.4])),
          ('celular + capinha', 190, cel.bounds.mean(axis=0)), ('cabos + step-up', 80, np.array([-8, 70, -25])),
          ]
M = sum(m for _, m, _ in items); c = sum(m*p for _, m, p in items)/M
for k, m, p in items: print(f'{k:20s} {m:6.0f} g   X {p[0]:6.1f}  Y {p[1]:7.1f}  Z {p[2]:7.1f}')
print(f'TOTAL {M:.0f} g   centro de massa: X {c[0]:.1f}  Y {c[1]:.1f}  Z {c[2]:.1f} mm')
HY_C = P('HY_C'); RAKE = P('CABO_RAKE'); H = P('CABO_H'); HF_Z0 = -44.4 - 4.5  # v6
hand_y = HY_C + 32*math.tan(math.radians(RAKE))
print(f'mão (1/3 do cabo): Y {hand_y:.1f}  -> CM fica {c[1] - hand_y:+.1f} mm em relação à mão')
# estabilidade em pé: polígono da base (elipse) e altura do CM
cabo = L('build/asm6/cabo.stl'); zmin = cabo.bounds[0][2]
v = cabo.vertices[cabo.vertices[:, 2] < zmin + 0.05][:, :2]
cx, cy = v[:, 0].mean(), (v[:, 1].max() + v[:, 1].min())/2
a, b = (v[:, 0].max() - v[:, 0].min())/2, (v[:, 1].max() - v[:, 1].min())/2
h = c[2] - zmin
deg = lambda d: math.degrees(math.atan(d/h))
print(f'base: centro X {cx:.1f} Y {cy:.1f}, semieixos {a:.1f} x {b:.1f} mm; CM {h:.0f} mm acima da mesa')
print(f'em pé tomba com: frente {deg(b + c[1] - cy):.1f}°, trás {deg(b - c[1] + cy):.1f}°, '
      f'esquerda {deg(a - (c[0] - cx)):.1f}°, direita {deg(a + (c[0] - cx)):.1f}°')
