"""Estimativa de filamento por camada (como um fatiador): 3 perímetros de 0,45 mm, 4 camadas sólidas em cima e
embaixo, preenchimento de 15 %, camada de 0,2 mm, PETG 1,27 g/cm3.  uso: python3 tools/filamento.py stl/*.stl"""
import sys, trimesh, numpy as np
from shapely.geometry import Polygon, MultiPolygon
from shapely.ops import unary_union
LH, SHELL, NTB, INF, RHO = 0.2, 3*0.45, 4, float(__import__('os').environ.get('INF', '0.15')), 1.27e-3
def layer_polys(m):
    z0, z1 = m.bounds[:, 2]
    zs = np.arange(z0 + LH/2, z1, LH)
    secs = m.section_multiplane(plane_origin=[0, 0, 0], plane_normal=[0, 0, 1], heights=list(zs))
    out = []
    for s in secs:
        if s is None: out.append(Polygon()); continue
        out.append(unary_union([p.buffer(0) for p in s.polygons_full]))
    return out
tot = 0
for f in sys.argv[1:]:
    m = trimesh.load(f, force='mesh'); L = layer_polys(m); n = len(L); g = 0.0
    for i, p in enumerate(L):
        if p.is_empty: continue
        shell = p.difference(p.buffer(-SHELL))
        if i - NTB < 0 or i + NTB >= n: inter = Polygon()
        else:
            inter = p
            for j in range(i - NTB, i + NTB + 1):
                inter = inter.intersection(L[j])
                if inter.is_empty: break
        solid = unary_union([shell, p.difference(inter)])
        a_s = solid.area; a = p.area
        g += (a_s + INF*max(0.0, a - a_s)) * LH * RHO
    tot += g
    print(f'{f.split("/")[-1]:14s} {g:6.1f} g   ({m.volume*RHO:6.1f} g se fosse maciço)')
print(f'TOTAL {tot:.0f} g')
