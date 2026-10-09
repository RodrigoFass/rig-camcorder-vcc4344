"""Gera scad/clip_v3_perfil.scad a partir do .3mf do clip do MakerWorld.

O clip "Ultimate Desk & Cockpit Phone Holder Clip v3" (RealNationPrint,
https://makerworld.com/models/1158094) é um perfil 2D extrudado. Este script lê o
.3mf que VOCÊ baixou, aplica a escala do perfil do autor (110 %) e grava só o
contorno, para o OpenSCAD montar o suporte fixo. O arquivo gerado é derivado do
modelo do autor: é para uso pessoal e não vai para o repositório (.gitignore).

uso (na raiz do repositório):  python3 tools/clip_perfil.py ClipV3.3mf [escala]
"""
import sys, re, zipfile, numpy as np, trimesh

src = sys.argv[1]
z = zipfile.ZipFile(src)
root = z.read('3D/3dmodel.model').decode('utf-8')
# escala do item da mesa (o perfil do autor usa 1,1); pode ser forçada no 2º argumento
item = re.search(r'<item [^>]*transform="([^"]+)"', root)
esc = float(sys.argv[2]) if len(sys.argv) > 2 else (float(item.group(1).split()[0]) if item else 1.0)
names = [n for n in z.namelist() if n.startswith('3D/Objects/') and n.endswith('.model')] or ['3D/3dmodel.model']
V, F, n0 = [], [], 0
for n in names:
    t = z.read(n).decode('utf-8')
    v = np.array(re.findall(r'<vertex x="([^"]+)" y="([^"]+)" z="([^"]+)"', t), dtype=float)
    f = np.array(re.findall(r'<triangle v1="(\d+)" v2="(\d+)" v3="(\d+)"', t), dtype=np.int64)
    if len(v) == 0: continue
    V.append(v); F.append(f + n0); n0 += len(v)
m = trimesh.Trimesh(np.vstack(V), np.vstack(F), process=True)
m.apply_translation(-m.bounds.mean(axis=0))
m.apply_scale(esc)
lo, hi = m.bounds
W = hi[2] - lo[2]
sec = m.section(plane_origin=[0, 0, 0], plane_normal=[0, 0, 1])
p2, _ = sec.to_2D(to_2D=np.eye(4))
poly = max(p2.polygons_full, key=lambda q: q.area).simplify(0.01, preserve_topology=True)
assert len(poly.interiors) == 0, 'o perfil tem furos: confira o arquivo'
# confere se é mesmo um perfil extrudado (mesma área perto das duas pontas)
for zz in (lo[2] + 1, hi[2] - 1):
    s = m.section(plane_origin=[0, 0, zz], plane_normal=[0, 0, 1]).to_2D(to_2D=np.eye(4))[0]
    assert abs(s.area - poly.area) < 0.01*poly.area, 'o clip não é um perfil extrudado'
pts = np.array(poly.exterior.coords)[:-1]
out = 'scad/clip_v3_perfil.scad'
with open(out, 'w') as fh:
    fh.write('// GERADO por tools/clip_perfil.py a partir de "%s" (escala %.3g).\n' % (src.split('/')[-1], esc))
    fh.write('// Derivado do clip de RealNationPrint no MakerWorld: uso pessoal, NÃO redistribua.\n')
    fh.write('CLIP_W = %.3f;\n' % W)
    fh.write('CLIP_P = [' + ','.join('[%.3f,%.3f]' % (x, y) for x, y in pts) + '];\n')
print(f'{out}: {len(pts)} pontos, {poly.bounds[2]-poly.bounds[0]:.1f} x {poly.bounds[3]-poly.bounds[1]:.1f} mm, largura {W:.2f} mm, escala {esc}')
