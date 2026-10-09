// SPDX-License-Identifier: CC-BY-SA-4.0   © 2026 Rodrigo (github.com/RodrigoFass)
// =====================================================================
//  Rig camcorder v6 — Sanyo VCC-4344  (100 % impresso: nenhum parafuso, porca ou peça de metal)
//  A câmera (metal) é a estrutura e fica só encaixada; nenhum parafuso da câmera é usado.
//  Tudo o que rosqueia é impresso: rosca de 8 mm, passo 2 (perfil liso de círculo excêntrico torcido).
//    • berço   : abraça a base da câmera. A câmera entra por trás: o ferro corre sobre a sela, entre
//                duas bochechas, até o batente da frente. Duas colunas com lábios em cunha seguram a
//                ponte do topo. Power bank preso por molas e trava traseira; EasyCap numa caixa fechada
//                no lado +X, com tampa deslizante.
//    • topo    : ponte que entra por trás sob os lábios das colunas e aperta a câmera ao ser empurrada
//                para a frente (cunha). O pino rosqueado do giro sai impresso junto.
//    • cabo    : empunhadura presa por baioneta em rabo de andorinha (2 garras entram por janelas e
//                correm 13 mm para a frente), travada por uma chave que entra pelo lado −X.
//    • garfo, braço, garra, mordente: giro, inclinação e rolagem do celular, com parafusos, porcas e
//                botões impressos. A garra abre de 70 a 90 mm (altura + espessura do celular).
//  Coordenadas (mm): X = largura (+X = esquerda do operador), Y = comprimento (lente em −Y),
//  Z = altura; origem no centro do corpo da câmera.
//    • extras : trava da ponte (moldura em volta das colunas) e trava lateral do celular ajustável
//    • opção fixa: clip de mola do MakerWorld na base do giro, no lugar da articulação (veja o fim do arquivo)
//  Uso: openscad -D 'PART="berco"' -o berco.stl camcorder_rig_v6.scad
//       PART = montagem (com o clip) | montagem_articulada | topo | berco | tampa | cabo | garfo | braco | garra |
//              mordente | parafusos | trava_ponte | trava_celular | clip | porca_clip | testes_petg | testes_pla
// =====================================================================

PART = "montagem";
$fn = 64;

// ---------------------------------------------------------- câmera (manual + fotos)
CAM_W = 67;  CAM_L = 126.5;  CAM_H = 54;  CAM_R = 4.5;
YF = -CAM_L/2;  YB = CAM_L/2;  ZT = CAM_H/2;  ZB = -CAM_H/2;
BRK_Y0 = YF + 8;  BRK_Y1 = YF + 33;  BRK_UW = 21.6;  BRK_H = 12;
BRK_ZB = ZB - BRK_H + 0.02;                  // fundo da chapa do ferro (−38,98)
BUCHA_Y = YF + 22.5;  BUCHA_R = 4.3;  BUCHA_H = 1.2;

// ---------------------------------------------------------- componentes (confira com paquímetro)
PB = [124, 67, 13];         // power bank: comprimento (Y), largura (X), espessura (Z)
EC_A = 73;  EC_B = 26;  EC_C = 15.5;  EC = [EC_A, EC_B, EC_C];        // EasyCap sem o plugue (scan: ~72 x 25,5 x 15): comprimento (Y), altura (Z), espessura (X)
PH = [151.7, 71.2, 7.9];    // celular na montagem (Galaxy S21): comprimento, altura, espessura

// ---------------------------------------------------------- roscas impressas
TH_D = 8;  TH_P = 2;        // diâmetro externo e passo
TH_E = 0.5;                 // excentricidade (a rosca tem 2·TH_E = 1 mm de profundidade)
TH_CL = 0.3;                // folga radial da fêmea (ajuste com a peça de teste)

// ---------------------------------------------------------- berço
CL = 0.4;  W = 2.0;                          // folga lateral e parede
XI = max(PB[1], CAM_W)/2 + CL;               // face interna das paredes (33,9)
XO = XI + W;                                 // face externa (35,9)
Z_PB0 = ZB - PB[2];                          // fundo do power bank (−40); o topo encosta na câmera
SPR_GAP = 2.4;                               // vão das molas embaixo do power bank
LIP_Z1 = Z_PB0 - SPR_GAP;                    // topo das abas (−42,4)
LIP_Z0 = LIP_Z1 - 2.0;                       // fundo do berço (−44,4)
XL = XI - 6;                                 // borda interna das abas (27,9)
WALL_Z1 = ZB + 8;                            // paredes sobem 8 mm nas laterais da câmera
WALL_Z1B = ZB + 1;                           // atrás da câmera só seguram o power bank
PB_Y0 = BRK_Y1 + 0.4;  PB_Y1 = PB_Y0 + PB[0];
CH_Y0 = BRK_Y0;  CH_Y1 = PB_Y1 + 5;
// sela sob o ferro: bochechas dos lados, batente na frente e canal da bucha (a câmera entra por trás)
SAD_Z1 = BRK_ZB - 0.02;  SAD_Y1 = PB_Y0 - 0.6;
SC_X0 = BRK_UW/2 + 0.3;  SC_X1 = SC_X0 + 3;  SC_Z1 = ZB - 4;      // bochechas (faces internas a 0,3 mm do ferro)
FEN_Y1 = BRK_Y0 - 0.35;  FEN_Y0 = FEN_Y1 - 2.25;                 // batente na frente do ferro
// molas: 4 linguetas que empurram o power bank contra a câmera (absorvem ±1 mm de espessura)
SPR_X = 27.5;  SPR_W = 5;  SPR_L = 28;  SPR_UP = 1.3;
SPR_YC = [PB_Y0 + 22, PB_Y0 + 74];           // crista das molas (sempre embaixo da câmera)
function spr_y0(yc) = yc - 22.5;
// trava traseira: lingueta em U no fundo; aperte a ponta para baixo para soltar
LAT_Y0 = PB_Y1 - 36;  LAT_X0 = 19;  LAT_X1 = 26;  LAT_T = 1.8;
HOOK_Y0 = PB_Y1 + 0.3;  HOOK_L = 3;  HOOK_Z = Z_PB0 + 3.2;  TAIL_Y1 = PB_Y1 + 13;
// caixa da EasyCap (+X): EasyCap deitada no fundo, adaptador OTG na frente, sobras de cabo por cima; tampa deslizante
EB_T = 1.8;                                  // paredes da caixa
EB_X0 = XO;  EB_X1 = XO + 20;                // faces internas (a de dentro é a parede do berço, prolongada)
EB_Y0 = -60;  EB_Y1 = 66;                    // faces internas da frente e de trás
EB_Z0 = LIP_Z0 + 2;  EB_Z1 = 2;              // fundo e topo do espaço interno
RL_W = 1.8;  GR_D = 1.0;  LID_T = 1.6;       // trilhos da tampa, fundo da canaleta, espessura da tampa
GR_Z0 = EB_Z1 + 1.0;  GR_Z1 = GR_Z0 + LID_T + 0.3;   // canaleta da tampa
RL_Z1 = GR_Z1 + 1.2;                         // topo dos trilhos e da frente
LID_X0 = EB_X0 + RL_W - GR_D + 0.3;  LID_X1 = EB_X1 - RL_W + GR_D - 0.3;
LID_Z0 = GR_Z0 + 0.15;  LID_Y1 = EB_Y1 + EB_T + 4;
// EasyCap na montagem: deitada no fundo, encostada na parede de fora, USB para a frente
EC_X0 = EB_X1 - EC[2] - 0.5;  EC_Y0 = -18;  EC_Z0 = EB_Z0;
TST_Y = 50.5;                                // fatia de teste do berço (inteira: travessa + caixa)
// janelas das paredes (ventilação e menos material)
WIN_Z0 = LIP_Z1 + 3.5;  WIN_Z1 = ZB + 1.5;
WIN_PX = [[-51, -35], [-15, 2], [12, 29.6]];
WIN_NX = [[-51, -35], [-26, -6], [0, 20], [23, 37.5]];

// ---------------------------------------------------------- cabo (empunhadura) e baioneta
HY_C = -2;                                   // centro do topo do cabo; fica sob o centro de massa
HF_Y0 = HY_C - 25;  HF_Y1 = HY_C + 25;       // piso do berço sobre o cabo
CABO_H = 96;  CABO_RAKE = 6;
HF_T = 4.5;  HF_Z1 = LIP_Z0;  HF_Z0 = HF_Z1 - HF_T;
CF_X = 20;  CF_Y0 = HY_C - 25;  CF_Y1 = HY_C + 22;   // flange do cabo (encosta embaixo do berço)
// rabo de andorinha a 45°: o berço tem o canal (bloco embaixo do power bank), o cabo tem 2 garras
DV_H = 3.2;  DV_N = 7;                       // altura e meia-largura do pescoço
DV_CL = 0.1;                                 // folga das garras; o canal estreita até a frente (cunha)
DV_L = 10;  DV_RUN = 13;                     // comprimento das garras e curso da baioneta
DV_Y = [HY_C - 24, HY_C + 1];                // frente das garras, assentadas
BLK_X = 22.6;  BLK_Y0 = HY_C - 25.5;  BLK_Y1 = HY_C + 25;
// chave: barra 3,2 x 1,9 mm que entra pelo lado −X, por baixo do berço, atrás da garra de trás
KEY_W = 3.2;  KEY_H = 1.9;  KEY_Y = DV_Y[1] + DV_L + 0.05;  KEY_X0 = -XO - 0.6;  KEY_X1 = 10;

// ---------------------------------------------------------- topo e articulação
ROOF = ZT;                                   // o topo apoia direto na câmera
TOPO_T = 3;  PAN_H = 4;
PC = -29.7;                                  // eixo do giro (Y)
YK_R = 17.5;  YK_T = 5;  CHEEK = 5;  GAP = 16.4;
GF_R = 17.5;                                 // raio do disco do garfo
Z_PAN = ROOF + TOPO_T + PAN_H;               // topo da base do giro / fundo do garfo (34)
// ponte do topo: desliza por trás sob os lábios das colunas; os lábios descem para a frente (cunha)
BR_Y0 = PC - 7.5;  BR_Y1 = PC + 7.5;  BR_Z1 = ROOF + TOPO_T;
BR_HX = CAM_W/2 + 0.1;                       // meia-largura da ponte (33,6)
COL_Y0 = PC - 13.5;  COL_Y1 = PC + 7.5;      // lábios (a ponte para 6 mm antes do batente: sobra curso)
LIP_X = XI - 2.5;  LIP_S = 0.12;             // borda interna dos lábios e inclinação da cunha
function lipz(y) = BR_Z1 + (y - BR_Y0)*LIP_S;    // fundo do lábio (= topo da cunha da ponte)
COL_Z1 = lipz(COL_Y1) + 2.2;                 // topo das colunas (34)
STOP_Y0 = COL_Y0 - 2;  STOP_Z0 = ROOF + 0.3; // batente da ponte (a câmera passa por baixo)
FIN_X = XO + 7;  FIN_T = 2.4;  FIN_Y = (STOP_Y0 + COL_Y1)/2;   // aleta de reforço das colunas
// giro: pino rosqueado da ponte, arruela com furo em D e porca sextavada; trava na frente
PW_T = 1.5;  PW_R = 8;  PIN_FLAT = 3;        // arruela e face plana do pino
PN_AF = 13;  PN_H = 6;  PN_Z0 = Z_PAN + YK_T + PW_T;
PIN_Z1 = PN_Z0 + PN_H - 0.5;                 // ponta do pino (45,5... abaixo do braço)
PL_Y = PC - 15;  PLK_D = 13;  PLK_H = 6;  PLK_Z0 = Z_PAN + YK_T + 2;     // trava do giro (2 mm de curso para apertar)
// inclinação: parafuso de cabeça sextavada presa na orelha −X + porca-botão do lado +X
Z_TILT = Z_PAN + YK_T + 17;                  // eixo da inclinação (56)
GF_CR = 8;                                   // raio das orelhas do garfo no eixo
TL_HD = 15;  TL_HH = 3;                      // cabeça redonda do parafuso (fica fora da orelha −X)
TK_D = 20;  TK_H = 9;  TK_X0 = GAP/2 + CHEEK + 0.2;
TL_X0 = -GAP/2 - CHEEK;                      // face de fora da orelha −X = começo da rosca
TL_X1 = TK_X0 + TK_H - 0.5;                  // ponta do parafuso
ARM_W = GAP - 0.6;  ARM_LEN = 42;  Z_ROLL = Z_TILT + ARM_LEN;  BOSS_T = 7;
PAN = 0;  TILT = 0;  ROLL = 0;
// garra ajustável
G_YB = PC + 4 + BOSS_T + 0.05;               // frente da espinha (encosta no braço)
SP_T = 5;  SP_WF = 8.6;  SP_WB = 10;         // espinha em rabo de andorinha (meia-largura frente/trás)
SP_CL = 0.25;  MB_T = 3;                     // folga e parede de trás do mordente
Y_C = G_YB + SP_T + SP_CL + MB_T + 1 + 6;    // plano médio do celular
V_D = 6.5;  JAW_W = 22;                      // mandíbulas em V (só tocam as quinas do celular)
JAW_FRONT = Y_C + V_D + 1.5;
OPEN_MIN = 70;  OPEN_MAX = 90;               // abertura = altura + espessura do celular
OPEN = PH[1] + PH[2];                        // abertura na montagem (S21: 79,1)
Z_VB = Z_ROLL - OPEN/2;                      // vértice do V de baixo (celular centrado no eixo de rolagem)
Z_VT = Z_VB + OPEN;
SL_H = 13;                                   // manga do mordente acima da mandíbula
SP_Z0 = Z_VB - 3.5;
DT_Z0 = Z_VB + OPEN_MIN - V_D - 1;
SP_Z1 = Z_VB + OPEN_MAX + 3 + SL_H + 1;
// rolagem: parafuso com botão pela frente, rosqueado na garra
RK_D = 20;  RK_H = 7;  RL_Y1 = G_YB + SP_T + 2 - 0.5;
// mordente: parafuso com botão atrás, rosqueado no mordente, aperta a espinha
MO_B = 5;  MK_D = 13;  MK_H = 7;

// =====================================================================
module rrect(x, y, r) { offset(r) square([x - 2*r, y - 2*r], center = true); }
module hexnut(af, h) { cylinder(r = af/sqrt(3), h = h, $fn = 6); }
// perfil 2D (u → Y, v → Z) extrudado ao longo de X, de x0 a x1
module along_x(x0, x1) { translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) children(); }
// perfil 2D (u → X, v → Z) extrudado ao longo de Y, de y0 a y1
module along_y(y0, y1) { translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children(); }
module gota2d(r, a = 90) { hull() { circle(r = r, $fn = 40); rotate(a) translate([r*sqrt(2), 0]) square(0.02, center = true); } }   // furo em gota (teto a 45°)
module gancho() {        // gancho para cabo de ~3,5–4 mm (abre para cima)
    difference() {
        cube([7, 8, 7]);
        translate([3.5, -1, 4.0]) rotate([-90, 0, 0]) cylinder(r = 2.1, h = 10, $fn = 32);
        translate([3.5 - 1.5, -1, 4.0]) cube([3.0, 10, 5]);
    }
}

// ---------------------------------------------------------- roscas
// Rosca de entrada única feita com um círculo excêntrico torcido: perfil liso, sem pontas, imprime bem
// em pé. A fase depende só da posição ao longo do eixo (z local), então macho e fêmea montados no
// mesmo eixo sempre casam. Rosca direita (aperta no sentido horário).
module rosca(z0, z1, cl = 0) {
    translate([0, 0, z0]) rotate([0, 0, 360*z0/TH_P])
        linear_extrude(height = z1 - z0, twist = -360*(z1 - z0)/TH_P, slices = max(4, ceil((z1 - z0)/TH_P*16)), convexity = 6)
            translate([TH_E, 0]) circle(r = TH_D/2 - TH_E + cl, $fn = 40);
}
module macho(z0, z1, ch0 = false, ch1 = true) {      // parafuso, com ponta(s) chanfrada(s)
    r = TH_D/2 + 0.1;  c = 1;
    intersection() {
        rosca(z0, z1);
        hull() {
            translate([0, 0, z0]) cylinder(r = ch0 ? r - c : r, h = 0.01, $fn = 40);
            translate([0, 0, z0 + (ch0 ? c : 0)]) cylinder(r = r, h = 0.01, $fn = 40);
            translate([0, 0, z1 - (ch1 ? c : 0) - 0.01]) cylinder(r = r, h = 0.01, $fn = 40);
            translate([0, 0, z1 - 0.01]) cylinder(r = ch1 ? r - c : r, h = 0.01, $fn = 40);
        }
    }
}
module femea(z0, z1, ch0 = true, ch1 = true) {       // furo rosqueado, com chanfro de entrada
    rosca(z0 - 0.01, z1 + 0.01, TH_CL);
    rmin = TH_D/2 - 2*TH_E + TH_CL;  rmax = TH_D/2 + TH_CL + 0.4;
    if (ch0) translate([0, 0, z0 - 0.01]) cylinder(r1 = rmax, r2 = rmin, h = rmax - rmin, $fn = 40);
    if (ch1) translate([0, 0, z1 + 0.01 - (rmax - rmin)]) cylinder(r1 = rmin, r2 = rmax, h = rmax - rmin, $fn = 40);
}
// botão serrilhado (z de 0 a h)
module knob(d, h, n = 12) {
    difference() {
        hull() {
            cylinder(r = d/2 - 0.8, h = 0.01);
            translate([0, 0, 0.8]) cylinder(r = d/2, h = h - 1.6);
            translate([0, 0, h - 0.01]) cylinder(r = d/2 - 0.8, h = 0.01);
        }
        for (i = [0 : n - 1]) rotate([0, 0, i*360/n]) translate([d/2 + 0.5, 0, -1]) cylinder(r = 1.5, h = h + 2, $fn = 16);
    }
}
// eixos das juntas (z local = sentido do eixo; as roscas usam z local como fase)
module f_giro()   { translate([0, PC, 0]) children(); }                    // z local = Z
module f_trava()  { translate([0, PL_Y, 0]) children(); }                  // z local = Z
module f_incl()   { translate([0, PC, Z_TILT]) rotate([0, 90, 0]) children(); }   // z local = +X
module f_rol()    { translate([0, 0, Z_ROLL]) rotate([-90, 0, 0]) children(); }   // z local = +Y
module f_mord(kz) { translate([0, 0, kz]) rotate([-90, 0, 0]) children(); }       // z local = +Y

// =====================================================================
//  TOPO (base do giro)
// =====================================================================
module pino_giro() {     // pino rosqueado do giro, com face plana que trava a arruela
    intersection() {
        macho(Z_PAN - 0.5, PIN_Z1);
        translate([-10, -10, 0]) cube([10 + PIN_FLAT, 20, 100]);
    }
}
module topo() {          // ponte sobre a câmera: base do giro; entra por trás sob os lábios das colunas
    difference() {
        union() {
            translate([-BR_HX, BR_Y0, ROOF]) cube([2*BR_HX, BR_Y1 - BR_Y0, TOPO_T]);
            translate([0, PC, ROOF]) cylinder(r = YK_R, h = TOPO_T + PAN_H);
            translate([22, BR_Y0 - 9, ROOF]) cube([8, 9.01, TOPO_T]);          // aba do gancho
            // cunhas nas pontas (paralelas ao fundo dos lábios)
            for (m = [0, 1]) mirror([m, 0, 0])
                along_x(LIP_X - 0.3, BR_HX) polygon([[BR_Y0, BR_Z1 - 0.3], [BR_Y1, BR_Z1 - 0.3], [BR_Y1, lipz(BR_Y1) - 0.05], [BR_Y0, lipz(BR_Y0) - 0.05]]);
        }
        for (s = [-1, 1]) translate([s > 0 ? 18.5 : -30.5, BR_Y0 + 3.5, ROOF - 1]) cube([12, BR_Y1 - BR_Y0 - 7, TOPO_T + 2]);   // alívio
    }
    translate([22.5, BR_Y0 - 8.5, ROOF + TOPO_T - 0.01]) gancho();
    f_giro() pino_giro();
}

// =====================================================================
//  BERÇO
// =====================================================================
module janela(y0, y1) {          // janela hexagonal (pontas a 45°: imprime sem suporte)
    h = WIN_Z1 - WIN_Z0;
    polygon([[y0, WIN_Z0 + h/2], [y0 + h/2, WIN_Z1], [y1 - h/2, WIN_Z1], [y1, WIN_Z0 + h/2], [y1 - h/2, WIN_Z0], [y0 + h/2, WIN_Z0]]);
}
module parede(s) {
    x0 = (s > 0) ? XI : -XO;
    along_x(x0, x0 + W) polygon([[CH_Y0, LIP_Z0], [CH_Y1, LIP_Z0], [CH_Y1, WALL_Z1B], [YB + 4, WALL_Z1B],
                                 [YB - 1, WALL_Z1], [CH_Y0, WALL_Z1]]);
}
CN_Y1 = -38.6;  CN_Z0 = -8;  CN_Z1 = 11;     // ressalto redondo no lado −X da câmera (Y −52,9..−39,6; Z −5,3..8)
module coluna(s) {       // sobe pela lateral da câmera; lábio em cunha, batente e aleta de reforço
    xi = (s > 0) ? XI : XI + 1;                // lado −X: 1 mm mais para fora (o ressalto da câmera passa)
    mirror([s > 0 ? 0 : 1, 0, 0]) difference() {
      union() {
        translate([xi, STOP_Y0, WALL_Z1 - 0.01]) cube([W, COL_Y1 - STOP_Y0, COL_Z1 - WALL_Z1 + 0.01]);
        along_x(LIP_X, xi + 0.05) polygon([[STOP_Y0, STOP_Z0], [COL_Y0, STOP_Z0], [COL_Y0, lipz(COL_Y0)], [COL_Y1, lipz(COL_Y1)],
                                           [COL_Y1, COL_Z1], [STOP_Y0, COL_Z1]]);
        za = (s > 0) ? RL_Z1 : WALL_Z1 - 11;     // +X: nasce sobre o trilho da caixa; −X: na parede
        xa = (s > 0) ? XO + RL_W : XO;
        along_y(FIN_Y - FIN_T/2, FIN_Y + FIN_T/2)
            polygon([[XO - 0.05, za], [xa, za], [FIN_X, za + FIN_X - xa], [FIN_X, COL_Z1], [XO - 0.05, COL_Z1]]);
      }
      // lado −X: recorte na frente da coluna, livre para o ressalto/conector (teto a 45°)
      if (s < 0) along_x(xi - 1, xi + W + 1)
          polygon([[CN_Y1, CN_Z0], [CN_Y1, CN_Z1], [STOP_Y0 - 1, CN_Z1 + CN_Y1 - STOP_Y0 + 1], [STOP_Y0 - 1, CN_Z0]]);
    }
}
module sela() {                  // sob o ferro: bloco + bochechas dos lados + batente na frente
    translate([-SC_X1, FEN_Y0, LIP_Z0]) cube([2*SC_X1, SAD_Y1 - FEN_Y0, SAD_Z1 - LIP_Z0]);
    for (m = [0, 1]) mirror([m, 0, 0])
        along_y(FEN_Y0, SAD_Y1) polygon([[SC_X0, SAD_Z1 - 0.01], [SC_X1, SAD_Z1 - 0.01], [SC_X1, SC_Z1], [SC_X0 + 0.6, SC_Z1], [SC_X0, SC_Z1 - 0.6]]);
    translate([-SC_X1, FEN_Y0, SAD_Z1 - 0.01]) cube([2*SC_X1, FEN_Y1 - FEN_Y0, SC_Z1 - SAD_Z1 + 0.01]);
}
module sela_cortes() {
    // canal da bucha (o ferro desliza por trás com a bucha dentro dele)
    hull() for (y = [BUCHA_Y, SAD_Y1 + 1]) translate([0, y, SAD_Z1 - BUCHA_H - 0.4]) cylinder(r = BUCHA_R + 0.5, h = 5, $fn = 40);
    // entrada chanfrada das bochechas
    for (s = [-1, 1]) translate([s*SC_X0, SAD_Y1, SAD_Z1 + 5]) rotate([0, 0, 45]) cube([2.4, 2.4, 10], center = true);
}
module presilha(y) {             // passagem de abraçadeira (step-up), lado −X
    translate([-XO - 4, y, LIP_Z0]) difference() {
        cube([4.01, 8, 10]);
        translate([-0.01, -1, 3]) cube([2.2, 10, 4]);
    }
}
module caixa_easycap() {         // caixa fechada no lado +X (parede de dentro = parede do berço prolongada)
    h = RL_Z1 - LIP_Z0;  L = EB_Y1 - EB_Y0 + 2*EB_T;
    translate([XI, EB_Y0 - EB_T, LIP_Z0]) cube([W, L, h]);                                          // dentro
    translate([XO - 0.01, EB_Y0 - EB_T, LIP_Z0]) cube([EB_X1 - XO + EB_T + 0.01, L, EB_Z0 - LIP_Z0]); // fundo
    translate([EB_X1, EB_Y0 - EB_T, LIP_Z0]) cube([EB_T, L, h]);                                    // fora
    translate([XO - 0.01, EB_Y0 - EB_T, LIP_Z0]) cube([EB_X1 - XO + 0.02, EB_T, h]);                 // frente (a tampa encosta)
    translate([XO - 0.01, EB_Y1, LIP_Z0]) cube([EB_X1 - XO + 0.02, EB_T, GR_Z0 - 0.2 - LIP_Z0]);     // trás (a tampa passa por cima)
    // trilhos da tampa, com chanfro de 45° embaixo (imprime sem suporte)
    for (k = [0, 1]) {
        xw = (k == 0) ? EB_X0 : EB_X1;  d = (k == 0) ? 1 : -1;
        along_y(EB_Y0 - 0.01, EB_Y1 + EB_T) polygon([[xw - d*0.3, GR_Z0 - 0.6 - RL_W - 0.3], [xw, GR_Z0 - 0.6 - RL_W],
                                                      [xw + d*RL_W, GR_Z0 - 0.6], [xw + d*RL_W, RL_Z1], [xw - d*0.3, RL_Z1]]);
    }
}
module caixa_easycap_cortes() {
    xc = (EB_X0 + EB_X1)/2;
    for (k = [0, 1]) {                                                          // canaletas da tampa (entram por trás)
        xg = (k == 0) ? EB_X0 + RL_W - GR_D : EB_X1 - RL_W - 0.01;
        translate([xg, EB_Y0, GR_Z0]) cube([GR_D + 0.01, EB_Y1 - EB_Y0 + 10, GR_Z1 - GR_Z0]);
    }
    translate([EB_X0 - 0.2, EB_Y1 - 1, GR_Z0 - 0.2]) cube([EB_X1 - EB_X0 + 0.4, 10, 10]);                      // entrada da tampa
    translate([xc - 4.5, EB_Y0 - EB_T - 1, GR_Z0 - 11]) cube([9, EB_T + 2, 20]);   // rasgo do cabo OTG (frente)
    translate([xc - 5, EB_Y1 - 1, GR_Z0 - 13]) cube([10, EB_T + 2, 20]);           // rasgo dos cabos RCA (trás)
    for (y = [EB_Y0 + 6 : 26 : 30]) translate([EB_X0 + 3.5, y, LIP_Z0 - 1]) cube([EB_X1 - EB_X0 - 7, 18, 5]);   // janelas no fundo
    for (w = [[EB_Y0 + 8, EB_Y0 + 38], [EB_Y0 + 48, EB_Y0 + 78], [EB_Y0 + 88, EB_Y1 - 8]])   // respiros na parede de fora
        along_x(EB_X1 - 1, EB_X1 + EB_T + 1) polygon([[w[0], -19], [w[0] + 12, -31], [w[1] - 12, -31], [w[1], -19], [w[1] - 12, -7], [w[0] + 12, -7]]);
}
module tampa() {                  // tampa deslizante da caixa da EasyCap (posição de montagem)
    difference() {
        union() {
            translate([LID_X0, EB_Y0 + 0.3, LID_Z0]) cube([LID_X1 - LID_X0, LID_Y1 - EB_Y0 - 0.3, LID_T]);
            // dente do clique, na ponta da língua flexível: passa por cima da parede de trás
            translate([(LID_X0 + LID_X1)/2 - 4, EB_Y1 - 2.4, LID_Z0 - 0.8]) cube([8, 1.6, 0.81]);
        }
        // língua flexível (fenda em U)
        for (dx = [-5, 4]) translate([(LID_X0 + LID_X1)/2 + dx, EB_Y1 - 20, LID_Z0 - 1]) cube([1, 21.5, LID_T + 2]);
        translate([(LID_X0 + LID_X1)/2 - 5, EB_Y1 + 0.5, LID_Z0 - 1]) cube([10, 1, LID_T + 2]);
        // puxador (rasgo para a unha) e respiros
        translate([(LID_X0 + LID_X1)/2 - 4, LID_Y1 - 3.5, LID_Z0 - 1]) cube([8, 2, LID_T + 2]);
        for (y = [EB_Y0 + 12 : 12 : EB_Y1 - 30]) translate([(LID_X0 + LID_X1)/2 - 4.5, y, LID_Z0 - 1]) cube([9, 3, LID_T + 2]);
    }
}
module mola_corte(yc) {
    y0 = spr_y0(yc);
    difference() {
        translate([SPR_X - SPR_W/2 - 0.8, y0, LIP_Z0 - 1]) cube([SPR_W + 1.6, SPR_L + 0.8, LIP_Z1 - LIP_Z0 + 2]);
        translate([SPR_X - SPR_W/2, y0 - 1, LIP_Z0 - 2]) cube([SPR_W, SPR_L + 1, LIP_Z1 - LIP_Z0 + 4]);
    }
}
module mola_ressalto(yc) {
    y0 = spr_y0(yc);  zt = Z_PB0 + SPR_UP;
    along_x(SPR_X - SPR_W/2, SPR_X + SPR_W/2)
        polygon([[y0 + 17, LIP_Z1 - 0.3], [y0 + 21, zt], [y0 + 24, zt], [y0 + SPR_L - 0.4, LIP_Z1 - 0.3]]);
}
module trava_traseira() {
    for (s = [-1, 1]) {
        translate([s > 0 ? LAT_X0 : -LAT_X1, LAT_Y0 - 0.01, LIP_Z0]) cube([LAT_X1 - LAT_X0, HOOK_Y0 + HOOK_L - LAT_Y0, LAT_T]);
        // gancho: face reta contra a traseira do power bank, rampa atrás
        along_x(s > 0 ? LAT_X0 : -LAT_X1, s > 0 ? LAT_X1 : -LAT_X0)
            polygon([[HOOK_Y0, LIP_Z0 + LAT_T - 0.01], [HOOK_Y0, HOOK_Z], [HOOK_Y0 + HOOK_L, HOOK_Z],
                     [HOOK_Y0 + HOOK_L + 7, LIP_Z0 + LAT_T - 0.01]]);
    }
    translate([-LAT_X1, HOOK_Y0 + HOOK_L - 0.01, LIP_Z0]) cube([2*LAT_X1, TAIL_Y1 - HOOK_Y0 - HOOK_L, LAT_T]);   // cauda
    for (y = [TAIL_Y1 - 6, TAIL_Y1 - 3]) translate([-LAT_X1 + 3, y, LIP_Z0 + LAT_T - 0.01]) cube([2*LAT_X1 - 6, 1.2, 0.8]);   // ranhuras
}
// ---- baioneta do cabo: canal em rabo de andorinha aberto por baixo (o vazio alarga para cima a 45°)
function dv_perfil(n) = [[-n, LIP_Z0 - 1], [n, LIP_Z0 - 1], [n, LIP_Z0], [n + DV_H + 0.02, LIP_Z0 + DV_H + 0.02], [n + DV_H + 0.02, LIP_Z0 + DV_H + 2],
                         [-n - DV_H - 0.02, LIP_Z0 + DV_H + 2], [-n - DV_H - 0.02, LIP_Z0 + DV_H + 0.02], [-n, LIP_Z0]];
module dv_fatia(y, n) { along_y(y, y + 0.01) polygon(dv_perfil(n)); }
module baioneta_cortes() {
    nt = DV_N - DV_CL - 0.03;  nl = DV_N + 0.15;      // pescoço justo (na frente de cada trecho) e folgado
    wx = DV_N + DV_H + 0.3;
    for (i = [0, 1]) {
        y0 = DV_Y[i] - 0.1;  yw = DV_Y[i] + DV_RUN - 0.25;     // trecho com lábios: da frente até a janela
        hull() { dv_fatia(y0, nt); dv_fatia(yw, nl); }
        y1 = (i == 0) ? DV_Y[1] - 0.1 : BLK_Y1 + 1;                // janela por onde a garra sobe
        translate([-wx, yw, LIP_Z0 - 1]) cube([2*wx, y1 - yw, DV_H + 2]);
    }
    // canal da chave (entra pelo lado −X, por baixo)
    translate([KEY_X0 - 5, KEY_Y - 0.1, LIP_Z0 - 1]) cube([KEY_X1 + 0.4 - KEY_X0 + 5, KEY_W + 0.2, KEY_H + 1.15]);
}
module berco(janelas = true) {
    difference() {
        union() {
            for (s = [-1, 1]) parede(s);
            // abas sob o power bank (toda a extensão)
            for (s = [-1, 1]) translate([s > 0 ? XL : -XI, CH_Y0, LIP_Z0]) cube([XI - XL, CH_Y1 - CH_Y0, LIP_Z1 - LIP_Z0]);
            // piso da frente + sela sob o ferro
            translate([-XI, CH_Y0, LIP_Z0]) cube([2*XI, SAD_Y1 - CH_Y0, LIP_Z1 - LIP_Z0]);
            sela();
            // piso do cabo + bloco da baioneta
            translate([-XI, HF_Y0, LIP_Z0]) cube([2*XI, HF_Y1 - HF_Y0, LIP_Z1 - LIP_Z0]);
            translate([-BLK_X, BLK_Y0, LIP_Z0]) cube([2*BLK_X, BLK_Y1 - BLK_Y0, DV_H]);
            // regiões alargadas em volta das molas
            for (m = [0, 1]) mirror([m, 0, 0]) for (yc = SPR_YC)
                translate([SPR_X - SPR_W/2 - 3, spr_y0(yc) - 2, LIP_Z0]) cube([XI - (SPR_X - SPR_W/2 - 3), SPR_L + 4.8, LIP_Z1 - LIP_Z0]);
            // travessa onde nasce a trava traseira
            translate([-XI, LAT_Y0 - 4, LIP_Z0]) cube([2*XI, 4.01, LIP_Z1 - LIP_Z0]);
            caixa_easycap();
            for (s = [-1, 1]) coluna(s);
            for (y = [68, 84]) presilha(y);
        }
        sela_cortes();
        // alívios do piso da frente
        for (s = [-1, 1]) translate([s > 0 ? SC_X1 + 2 : -XL + 1, CH_Y0 + 4, LIP_Z0 - 1]) cube([XL - 1 - SC_X1 - 2, 16, 5]);
        baioneta_cortes();
        caixa_easycap_cortes();
        // molas
        for (m = [0, 1]) mirror([m, 0, 0]) for (yc = SPR_YC) mola_corte(yc);
        // janelas
        if (janelas) {
            for (w = WIN_PX) along_x(XI - 1, XO + 1) janela(w[0], w[1]);
            for (w = WIN_NX) along_x(-XO - 1, -XI + 1) janela(w[0], w[1]);
        }
    }
    for (m = [0, 1]) mirror([m, 0, 0]) for (yc = SPR_YC) mola_ressalto(yc);
    trava_traseira();
}
module chave() {         // chave da baioneta: barra que entra pelo lado −X, por baixo do berço
    translate([KEY_X0, KEY_Y, LIP_Z0]) cube([KEY_X1 - KEY_X0, KEY_W, KEY_H]);
    translate([KEY_X0 - 8, KEY_Y + KEY_W/2, LIP_Z0 + KEY_H - 4.4]) difference() {    // puxador, fora da parede
        hull() { translate([4, -5, 0]) cube([4.01, 10, 4.4]); translate([3, 0, 0]) cylinder(r = 5, h = 4.4, $fn = 32); }
        translate([3, 0, -1]) cylinder(r = 2.2, h = 7, $fn = 24);
    }
}

// =====================================================================
//  CABO (empunhadura)
// =====================================================================
function csec(h) = let(
    t = h / CABO_H,
    a = 13.6 + 0.9*sin(180*min(1, t*1.12)) + 1.2*pow(max(0, t - 0.8)/0.2, 2),
    b = 15.6 - 0.5*sin(180*t) + 1.4*pow(max(0, t - 0.8)/0.2, 2),
    y = HY_C + h*tan(CABO_RAKE)
) [a, b, y];
BASE = [csec(CABO_H - 6)[0] + 5.5, csec(CABO_H - 6)[1] + 5.5];   // semieixos da base (flare de 45°)
module csl(h, g = 0) { s = csec(h); translate([0, s[2], HF_Z0 - h]) scale([s[0] + g, s[1] + g, 1]) cylinder(r = 1, h = 0.01, $fn = 72); }
module garra_dv(y0) {    // garra macho da baioneta (posição assentada)
    n = DV_N - DV_CL;  t = DV_H - 0.2;
    difference() {
        along_y(y0, y0 + DV_L) polygon([[-n, HF_Z1 - 0.5], [n, HF_Z1 - 0.5], [n, HF_Z1], [n + t, HF_Z1 + t], [-n - t, HF_Z1 + t], [-n, HF_Z1]]);
        translate([0, y0, HF_Z1 + t]) rotate([45, 0, 0]) cube([30, 1.4, 1.4], center = true);   // entrada chanfrada
    }
}
module cabo() {
    difference() {
        union() {
            hull() {             // flange: encosta embaixo do berço; chanfro de 45° por baixo (imprime em pé)
                translate([0, (CF_Y0 + CF_Y1)/2, HF_Z0]) linear_extrude(HF_T) rrect(2*CF_X, CF_Y1 - CF_Y0, 12);
                csl(14);
            }
            hs = [14, 24, 36, 48, 60, 70, 78, 85, CABO_H - 6];
            for (i = [0 : len(hs) - 2]) hull() { csl(hs[i]); csl(hs[i+1]); }
            // base alargada a 45° (o rig fica em pé na mesa)
            s = csec(CABO_H);
            hull() {
                csl(CABO_H - 6);
                translate([0, s[2], HF_Z0 - CABO_H]) scale([BASE[0], BASE[1], 1]) cylinder(r = 1, h = 0.01, $fn = 72);
                translate([0, s[2], HF_Z0 - CABO_H - 1]) scale([BASE[0] - 1, BASE[1] - 1, 1]) cylinder(r = 1, h = 0.01, $fn = 72);
            }
            for (y = DV_Y) garra_dv(y);
        }
        for (h = [24, 42, 60]) {     // apoio dos dedos (frente)
            s = csec(h);
            translate([-30, s[2] - s[1] - 7 + 1.6, HF_Z0 - h]) rotate([0, 90, 0]) cylinder(r = 7, h = 60);
        }
        // furo do cordão (atrás, perto do fundo)
        sl = csec(CABO_H - 9);
        translate([-40, sl[2] + sl[1] - 6.5, HF_Z0 - CABO_H + 9]) rotate([0, 90, 0]) cylinder(r = 2.2, h = 80, $fn = 20);
    }
}

// =====================================================================
//  ARTICULAÇÃO DO CELULAR
// =====================================================================
module garfo() {        // gira sobre o topo (giro) e segura o eixo da inclinação
    difference() {
        union() {
            translate([0, PC, Z_PAN]) cylinder(r = GF_R, h = YK_T);
            hull() { translate([0, PC, Z_PAN]) cylinder(r = 9, h = YK_T); translate([0, PL_Y, Z_PAN]) cylinder(r = 6.5, h = YK_T); }   // orelha da trava
            for (s = [-1, 1]) hull() {
                translate([s > 0 ? GAP/2 : -GAP/2 - CHEEK, PC - 8, Z_PAN + YK_T - 0.01]) cube([CHEEK, 16, 1]);
                translate([s > 0 ? GAP/2 : -GAP/2 - CHEEK, PC, Z_TILT]) rotate([0, 90, 0]) cylinder(r = GF_CR, h = CHEEK);
            }
        }
        translate([0, PC, Z_PAN - 1]) cylinder(r = TH_D/2 + 0.4, h = YK_T + 2, $fn = 40);      // pino do giro
        f_trava() femea(Z_PAN, Z_PAN + YK_T);                                                  // trava do giro
        // eixo da inclinação: furo em D na orelha −X (o parafuso não gira; teto reto = ponte) e em gota na +X
        translate([-GAP/2 - CHEEK - 1, PC, Z_TILT]) rotate([0, 90, 0]) linear_extrude(CHEEK + 2)
            intersection() { circle(r = TH_D/2 + 0.4, $fn = 40); translate([-PIN_FLAT - 0.3, -10]) square([20, 20]); }
        along_x(GAP/2 - 1, GAP/2 + CHEEK + 1) translate([PC, Z_TILT]) gota2d(TH_D/2 + 0.4, 90);
    }
}
module braco() {        // liga o eixo da inclinação ao eixo da rolagem
    difference() {
        along_x(-ARM_W/2, ARM_W/2) difference() {
            hull() {
                translate([PC, Z_TILT]) circle(r = 8);
                translate([PC + 4, Z_ROLL - 9]) square([BOSS_T, 18]);
            }
            translate([PC - 30, Z_ROLL - 11]) square([34, 30]);     // assento plano do botão da rolagem
        }
        translate([-30, PC, Z_TILT]) rotate([0, 90, 0]) cylinder(r = TH_D/2 + 0.4, h = 60, $fn = 40);
        along_y(PC - 10, PC + 30) translate([0, Z_ROLL]) gota2d(TH_D/2 + 0.4, 0);            // eixo da rolagem (teto para +X: imprime de lado)
        along_x(-ARM_W/2 - 1, ARM_W/2 + 1) hull() {          // alívio
            translate([PC + 1.5, Z_TILT + 13]) circle(r = 3.2);
            translate([PC + 5.2, Z_ROLL - 14]) circle(r = 2.2);
        }
    }
}
module espinha_perfil() { polygon([[-SP_WF, G_YB], [SP_WF, G_YB], [SP_WB, G_YB + SP_T], [-SP_WB, G_YB + SP_T]]); }
module v_corte(z, dir) {         // V ao longo de X, vértice em (Y_C, z); dir = 1 abre para cima
    along_x(-50, 50) polygon([[Y_C, z], [Y_C + V_D + 1, z + dir*(V_D + 1)], [Y_C - V_D - 1, z + dir*(V_D + 1)]]);
}
module garra() {        // espinha + mandíbula de baixo (fixa)
    difference() {
        union() {
            translate([-7, G_YB, SP_Z0]) cube([14, SP_T, DT_Z0 - SP_Z0 + 0.01]);
            translate([0, 0, DT_Z0]) linear_extrude(SP_Z1 - DT_Z0) espinha_perfil();
            translate([0, G_YB, Z_ROLL]) rotate([-90, 0, 0]) cylinder(r = 7.5, h = SP_T + 2);
            translate([-JAW_W, G_YB, SP_Z0]) cube([2*JAW_W, JAW_FRONT - G_YB, Z_VB + V_D - SP_Z0]);
        }
        v_corte(Z_VB, 1);
        for (s = [-1, 1]) translate([s > 0 ? 9 : -19, G_YB - 1, SP_Z0 + 1.5]) cube([10, Y_C - 8 - G_YB + 1, Z_VB + 5 - SP_Z0 - 1.5]);   // alívios
        f_rol() femea(G_YB, G_YB + SP_T + 2);           // rolagem: o parafuso rosqueia aqui
    }
}
function mord_kz(zt) = zt + 3 + SL_H/2 + 0.5;
MK_Y0 = G_YB + SP_T + SP_CL + MB_T + MO_B + 3.3;    // botão do mordente: sobra 3,3 mm de curso para apertar (antes 0,3: não apertava)
module mordente(zt = Z_VT) {    // mandíbula de cima: desliza na espinha e trava com parafuso impresso
    z0 = zt - V_D;  z1 = zt + 3 + SL_H;  yb = G_YB + SP_T + SP_CL;  kz = mord_kz(zt);
    difference() {
        union() {
            translate([-(SP_WB + SP_CL + 2.6), G_YB, z0]) cube([2*(SP_WB + SP_CL + 2.6), yb + MB_T - G_YB, z1 - z0]);
            translate([-JAW_W, G_YB, z0]) cube([2*JAW_W, JAW_FRONT - G_YB, zt + 3 - z0]);
            translate([-6.5, yb + MB_T - 0.01, kz - 6.5]) cube([13, MO_B + 0.01, 13]);          // ressalto da rosca
        }
        translate([0, 0, z0 - 1]) linear_extrude(z1 - z0 + 2) offset(delta = SP_CL) espinha_perfil();
        v_corte(zt, -1);
        for (s = [-1, 1]) translate([s > 0 ? 14 : -20, G_YB - 1, zt - 5]) cube([6, Y_C - 8 - G_YB + 1, 6.5]);   // alívios
        f_mord(kz) femea(yb - 0.5, yb + MB_T + MO_B);
    }
}

// ---------------------------------------------------------- parafusos, porcas e botões impressos
// (cada um no sistema do seu eixo: z local ao longo do eixo; veja f_giro, f_incl…)
module arruela_giro() {          // arruela com furo em D: não gira com o garfo, então a porca não solta
    difference() {
        translate([0, 0, Z_PAN + YK_T]) cylinder(r = PW_R, h = PW_T);
        intersection() {
            cylinder(r = TH_D/2 + 0.35, h = 200, center = true, $fn = 40);
            translate([-10, -10, -100]) cube([10 + PIN_FLAT + 0.3, 20, 200]);
        }
    }
}
module porca_giro() { difference() { translate([0, 0, PN_Z0]) rotate([0, 0, 30]) hexnut(PN_AF, PN_H); femea(PN_Z0, PN_Z0 + PN_H); } }
module trava_giro() {            // parafuso da trava do giro: aperta a ponta na base do giro
    macho(Z_PAN + 0.05, PLK_Z0 + 0.01, true, false);
    translate([0, 0, PLK_Z0]) knob(PLK_D, PLK_H, 10);
}
module paraf_incl() {            // eixo da inclinação: rosca com face plana (trava no furo em D da orelha −X)
    translate([0, 0, TL_X0 - TL_HH]) cylinder(r1 = TL_HD/2 - 0.6, r2 = TL_HD/2, h = TL_HH, $fn = 48);
    intersection() {
        macho(TL_X0 - 0.01, TL_X1);
        translate([-PIN_FLAT, -10, -100]) cube([20, 20, 200]);      // z local = +X, x local = −Z: plano em cima
    }
}
module porca_incl() { difference() { translate([0, 0, TK_X0]) knob(TK_D, TK_H, 12); femea(TK_X0, TK_X0 + TK_H); } }
module paraf_rol() {             // rolagem: botão na frente do braço, rosqueia na garra
    translate([0, 0, PC + 4 - RK_H]) knob(RK_D, RK_H, 12);
    macho(PC + 4 - 0.01, RL_Y1);
}
module paraf_mord_local() {      // mordente: a ponta aperta a espinha
    macho(G_YB + SP_T + 0.05, MK_Y0 + 0.01, true, false);
    translate([0, 0, MK_Y0]) knob(MK_D, MK_H, 10);
}
module paraf_mord(zt = Z_VT) { f_mord(mord_kz(zt)) paraf_mord_local(); }

// conjunto móvel posicionado pelos ângulos (montagem)
module rot_pan()  { translate([0, PC, 0]) rotate([0, 0, PAN]) translate([0, -PC, 0]) children(); }
module rot_tilt() { translate([0, PC, Z_TILT]) rotate([TILT, 0, 0]) translate([0, -PC, -Z_TILT]) children(); }
module rot_roll() { translate([0, 0, Z_ROLL]) rotate([0, ROLL, 0]) translate([0, 0, -Z_ROLL]) children(); }

// =====================================================================
module camera_ref() {
    color("ivory") translate([0, 0, ZB]) linear_extrude(CAM_H) rrect(CAM_W, CAM_L, CAM_R);
    color("silver") translate([0, (BRK_Y0 + BRK_Y1)/2, ZB - BRK_H]) linear_extrude(BRK_H) rrect(BRK_UW, BRK_Y1 - BRK_Y0, 0.8);
    color("black") translate([0, YF, 0]) rotate([90, 0, 0]) cylinder(r = 16.6, h = 31);
}
module powerbank_ref() { color([0.1, 0.1, 0.12]) translate([0, (PB_Y0 + PB_Y1)/2, Z_PB0]) linear_extrude(PB[2]) rrect(PB[1], PB[0], 4); }
module easycap_ref() { color([0.08, 0.08, 0.08]) translate([EC_X0, EC_Y0, EC_Z0]) cube([EC[2], EC[0], EC[1]]); }
module phone_ref() { color([0.05, 0.05, 0.07]) translate([-PH[0]/2, Y_C - PH[2]/2, Z_VB + PH[2]/2]) cube([PH[0], PH[2], PH[1]]); }

if (PART == "montagem_articulada") {      // versão anterior: celular na articulação (giro, inclinação e rolagem)
    camera_ref(); powerbank_ref(); easycap_ref();
    color("dimgray") { berco(); topo(); cabo(); tampa(); }
    color("orange") { chave(); f_giro() { arruela_giro(); porca_giro(); } trava_ponte(); }
    rot_pan() {
        color("dimgray") garfo();
        color("orange") { f_trava() trava_giro(); f_incl() { paraf_incl(); porca_incl(); } }
        rot_tilt() {
            color("gray") braco();
            rot_roll() {
                color("dimgray") garra(); color("gray") mordente(Z_VT + TRV);
                color("orange") { f_rol() paraf_rol(); paraf_mord(Z_VT + TRV); trava_celular(); }
                translate([0, 0, TRV]) phone_ref();
            }
        }
    }
}
if (PART == "asm_topo")     topo();
if (PART == "asm_berco")    berco();
if (PART == "asm_cabo")     cabo();
if (PART == "asm_tampa")    tampa();
if (PART == "asm_chave")    chave();
if (PART == "asm_porca")    f_giro() { arruela_giro(); porca_giro(); }
if (PART == "asm_garfo")    garfo();
if (PART == "asm_trava")    f_trava() trava_giro();
if (PART == "asm_bincl")    f_incl() { paraf_incl(); porca_incl(); }
if (PART == "asm_braco")    braco();
if (PART == "asm_garra")    garra();
if (PART == "asm_brol")     f_rol() paraf_rol();
if (PART == "asm_mordente") mordente(Z_VT + TRV);     // com a calha da trava lateral
if (PART == "asm_bmord")    paraf_mord(Z_VT + TRV);
// orientação de impressão
if (PART == "topo")     translate([0, -PC, -ROOF]) topo();                                         // deitado
if (PART == "berco")    translate([0, 0, -LIP_Z0]) berco();                                        // fundo na mesa
if (PART == "tampa")    translate([0, 0, LID_Z0 + LID_T]) mirror([0, 0, 1]) tampa();               // de cabeça para baixo
if (PART == "cabo")     translate([0, -HY_C, -(HF_Z0 - CABO_H - 1)]) cabo();                       // em pé, base na mesa
if (PART == "garfo")    translate([0, -PC, -Z_PAN]) garfo();                                       // disco na mesa
if (PART == "braco")    rotate([0, -90, 0]) translate([ARM_W/2, -PC, -Z_TILT]) braco();            // de lado
if (PART == "garra")    rotate([90, 0, 0]) translate([0, -G_YB, -SP_Z0]) garra();                  // deitada na frente
if (PART == "mordente") rotate([90, 0, 0]) translate([0, -G_YB, -(Z_VT - V_D)]) mordente();        // deitado na frente
module pp(part) {                // cada parafuso/porca em pé, botão ou cabeça na mesa
    if (part == 0) translate([0, 0, -(TL_X0 - TL_HH)]) paraf_incl();
    if (part == 1) translate([0, 0, -TK_X0]) porca_incl();
    if (part == 2) translate([0, 0, -(PC + 4 - RK_H)]) paraf_rol();
    if (part == 3) translate([0, 0, PLK_Z0 + PLK_H]) rotate([180, 0, 0]) trava_giro();
    if (part == 4) translate([0, 0, MK_Y0 + MK_H]) rotate([180, 0, 0]) paraf_mord_local();
    if (part == 5) translate([0, 0, -PN_Z0]) porca_giro();
    if (part == 6) translate([0, 0, -(Z_PAN + YK_T)]) arruela_giro();
    if (part == 7) rotate([180, 0, 0]) translate([-KEY_X0, -KEY_Y, -(LIP_Z0 + KEY_H)]) chave();
}
if (PART == "parafusos") {
    pp(0);
    translate([24, 0, 0]) pp(1);
    translate([49, 0, 0]) pp(2);
    translate([0, 22, 0]) pp(3);
    translate([17, 22, 0]) pp(4);
    translate([34, 22, 0]) pp(5);
    translate([51, 22, 0]) pp(6);
    translate([-2, 36, 0]) pp(7);
}
if (PART == "pp")  pp(PP);       // uso interno (filamento por peça)
PP = 0;
if (PART == "testes") {          // provas rápidas de encaixe
    // fatia do berço (power bank + câmera + EasyCap), deitada
    rotate([90, 0, 0]) translate([0, -TST_Y, -LIP_Z0])
        intersection() { berco(false); translate([-100, TST_Y, -100]) cube([200, 8, 200]); }
    // fatia da espinha e do mordente (rabo de andorinha), em pé
    translate([0, 70, 0]) translate([0, -G_YB, -(Z_VT + 4)])
        intersection() { garra(); translate([-30, G_YB - 1, Z_VT + 4]) cube([60, 20, 10]); }
    translate([40, 70, 0]) translate([0, -G_YB, -(Z_VT + 4)])
        intersection() { mordente(); translate([-30, G_YB - 1, Z_VT + 4]) cube([60, 30, 10]); }
    // rosca: parafuso curto + porca (ajuste TH_CL se ficar justo ou folgado)
    translate([-30, 75, 0]) { knob(16, 5, 10); macho(4.99, 17); }
    translate([-52, 75, 0]) difference() { rotate([0, 0, 30]) hexnut(PN_AF, PN_H); femea(0, PN_H); }
    // baioneta: trecho da frente do canal (berço) + uma garra do cabo
    translate([0, 105, 0]) translate([0, -DV_Y[0] + 2, -LIP_Z0])
        intersection() { berco(false); translate([-BLK_X - 1, DV_Y[0] - 2, LIP_Z0 - 1]) cube([2*BLK_X + 2, 15, DV_H + 1]); }
    translate([0, 128, 0]) translate([0, -DV_Y[0] + 2, -(HF_Z1 - 2)])
        intersection() { cabo(); translate([-24, DV_Y[0] - 2, HF_Z1 - 2]) cube([48, DV_L + 4, 10]); }
}
// testes separados por material: PETG = partes do berço/tampa; PLA = o resto
if (PART == "testes_petg") {
    // fatia do berço (largura da câmera e do power bank, caixa da EasyCap e trilhos da tampa), deitada
    rotate([90, 0, 0]) translate([0, -TST_Y, -LIP_Z0])
        intersection() { berco(false); translate([-100, TST_Y, -100]) cube([200, 8, 200]); }
    // pedaço da tampa (corre nos trilhos da fatia acima), de cabeça para baixo
    translate([75, -25, 0]) translate([0, -EB_Y0, LID_Z0 + LID_T]) mirror([0, 0, 1])
        intersection() { tampa(); translate([0, EB_Y0, -50]) cube([100, 22, 100]); }
    // sela: batente, bochechas e começo do canal da bucha (o ferro deve entrar justo, sem forçar)
    translate([0, 30, 0]) translate([0, -FEN_Y0, -LIP_Z0])
        intersection() { berco(false); translate([-SC_X1 - 3, FEN_Y0, LIP_Z0 - 1]) cube([2*SC_X1 + 6, BUCHA_Y + 8 - FEN_Y0, 20]); }
    // trecho da frente do canal da baioneta (a garra do cabo, impressa em PLA, deve correr e apertar no fim)
    translate([0, 70, 0]) translate([0, -DV_Y[0] + 2, -LIP_Z0])
        intersection() { berco(false); translate([-BLK_X - 1, DV_Y[0] - 2, LIP_Z0 - 1]) cube([2*BLK_X + 2, 15, DV_H + 1]); }
}
if (PART == "testes_pla") {
    translate([0, 0, 0]) translate([0, -G_YB, -(Z_VT + 4)])
        intersection() { garra(); translate([-30, G_YB - 1, Z_VT + 4]) cube([60, 20, 10]); }
    translate([40, 0, 0]) translate([0, -G_YB, -(Z_VT + 4)])
        intersection() { mordente(); translate([-30, G_YB - 1, Z_VT + 4]) cube([60, 30, 10]); }
    translate([-30, 5, 0]) { knob(16, 5, 10); macho(4.99, 17); }
    translate([-52, 5, 0]) difference() { rotate([0, 0, 30]) hexnut(PN_AF, PN_H); femea(0, PN_H); }
    translate([0, 30, 0]) translate([0, -DV_Y[0] + 2, -(HF_Z1 - 2)])
        intersection() { cabo(); translate([-24, DV_Y[0] - 2, HF_Z1 - 2]) cube([48, DV_L + 4, 10]); }
}

// =====================================================================
//  PEÇAS EXTRAS (depois do primeiro teste)
// =====================================================================
// --- trava da ponte: moldura fechada (retângulo) em volta das 2 colunas brancas e da base do giro, deitada
//     em cima da câmera e abaixo do garfo. Segura as colunas juntas para os lábios não abrirem.
TR_Z0 = ROOF + 0.15;  TR_Z1 = Z_PAN - 1.5;   // altura da moldura (27,15..32,5): abaixo do garfo
TR_W = 3;                                    // largura das barras
TR_YF = PC - YK_R - 0.4 - TR_W;              // barra da frente (na frente da base do giro e do batente)
TR_YB = PC + YK_R + 0.3;                     // travessa de trás (logo atrás da base do giro)
TR_XO = FIN_X + 0.3;                         // laterais por fora das aletas das colunas
module trava_ponte() {
    ybk = COL_Y1 + 0.2;                      // logo atrás das colunas
    difference() {
        union() {
            // barra da frente e travessa de trás
            translate([-TR_XO - TR_W, TR_YF, TR_Z0]) cube([2*(TR_XO + TR_W), TR_W, TR_Z1 - TR_Z0]);
            translate([-(BR_HX - 0.1), TR_YB, TR_Z0]) cube([2*(BR_HX - 0.1), TR_W, TR_Z1 - TR_Z0]);
            for (sx = [-1, 1]) {
                xo = (sx > 0) ? XO : XO + 1;             // face de fora da coluna
                mirror([sx > 0 ? 0 : 1, 0, 0]) {
                    // laterais por fora das aletas, da frente até atrás das colunas
                    translate([TR_XO, TR_YF, TR_Z0]) cube([TR_W, ybk + 3.5 - TR_YF, TR_Z1 - TR_Z0]);
                    // volta por trás das colunas, ligando a lateral aos braços
                    translate([BR_HX - 0.1 - 6, ybk, TR_Z0]) cube([TR_XO + TR_W - (BR_HX - 0.1 - 6), 3.5, TR_Z1 - TR_Z0]);
                    // braços até a travessa de trás
                    translate([BR_HX - 0.1 - 6, ybk, TR_Z0]) cube([6, TR_YB + TR_W - ybk, TR_Z1 - TR_Z0]);
                    // garra que encosta na face de fora da coluna (atrás da aleta)
                    translate([xo + 0.2, FIN_Y + FIN_T/2 + 0.3, TR_Z0]) cube([3, ybk + 3.5 - (FIN_Y + FIN_T/2 + 0.3), TR_Z1 - TR_Z0]);
                }
            }
        }
    }
}
module trava_ponte_plana() { translate([0, 0, -TR_Z0]) trava_ponte(); }

// --- trava lateral do celular, AJUSTÁVEL: calha em V que assenta no V da mandíbula de baixo (2 dedos abraçam
//     as pontas da mandíbula) + 2 cursores que correm na calha e travam com parafuso-botão por baixo.
//     Cada cursor tem a parede que encosta na ponta do celular. Serve para celulares de ~140 a ~172 mm.
PHC_L = 155;                 // comprimento do celular na montagem (só para mostrar; os cursores correm)
TC_L = 100;                  // meia-largura da calha (o parafuso do cursor fica sempre sobre ela)
TC_O = 0.15;                 // folga entre a calha e o V da mandíbula
CU_L = 16;  CU_CL = 0.25;  CU_B = 6.5;  CU_H = 22;   // cursor: comprimento, folga, fundo abaixo do vértice, altura da parede
CU_KD = 13;  CU_KH = 5;  CU_GAP = 2;               // botão do cursor
function tc_perf() = [[-9.5, 8.91], [-6.5, 8.91], [0, 2.41], [6.5, 8.91], [9.5, 8.91], [9.5, 7.31], [7.16, 7.31], [0, TC_O],
                      [-7.16, 7.31], [-9.5, 7.31]];          // perfil da calha (y, z a partir do vértice da mandíbula)
module tc_2d(off = 0) { translate([Y_C, Z_VB]) offset(delta = off) polygon(tc_perf()); }
module calha_celular() {
    along_x(-TC_L, TC_L) tc_2d();
    for (m = [0, 1]) mirror([m, 0, 0])            // dedos: abraçam as pontas da mandíbula (só acima do vértice)
        along_x(JAW_W + 0.3, JAW_W + 2.6) translate([Y_C, Z_VB])          // preenche embaixo do V, encostado na ponta da mandíbula
            polygon([[-7.16, TC_O], [7.16, TC_O], [7.16, 7.31], [0.3, TC_O + 0.3], [-0.3, TC_O + 0.3], [-7.16, 7.31]]);
}
module cursor_local() {      // lado +X; x = 0 é a face que encosta no celular
    yo = 11.7;  zb = Z_VB - CU_B;  zt = Z_VB + 8.91 + 1.8;
    difference() {
        union() {
            translate([0, Y_C - yo, zb]) cube([CU_L, 2*yo, zt - zb]);
            // parede que encosta na ponta do celular
            translate([0, Y_C - 7, zb]) cube([2.5, 14, CU_H + Z_VB - zb]);
            hull() { translate([2.49, Y_C - 7, zt - 0.01]) cube([0.01, 14, 0.01]); translate([2.49, Y_C - 7, zt - 0.01]) cube([6, 14, 0.01]);
                     translate([2.49, Y_C - 7, zt + 5.5]) cube([0.01, 14, 0.01]); }      // reforço a 45°
        }
        along_x(-1, CU_L + 1) tc_2d(CU_CL);                         // a calha passa por dentro
        along_x(2.5, CU_L + 1) translate([Y_C, Z_VB]) polygon([[-7, 2.41 + 7], [0, 2.41], [7, 2.41 + 7], [7, 60], [-7, 60]]);   // vão do celular
        translate([CU_L/2 + 1.25, 0, 0]) f_cursor() femea(zb, Z_VB + TC_O);                                                   // rosca do botão
    }
}
module f_cursor() { translate([0, Y_C, 0]) children(); }
module paraf_cursor_local() {   // botão embaixo, a ponta aperta o vértice da calha por baixo
    zb = Z_VB - CU_B;
    translate([0, 0, zb - CU_GAP - CU_KH]) knob(CU_KD, CU_KH, 10);
    macho(zb - CU_GAP - 0.01, Z_VB + TC_O - 0.05);
}
module trava_celular(L = PHC_L) {
    calha_celular();
    for (m = [0, 1]) mirror([m, 0, 0]) translate([L/2, 0, 0]) {
        cursor_local();
        translate([CU_L/2 + 1.25, 0, 0]) f_cursor() paraf_cursor_local();
    }
}
if (PART == "asm_trava_ponte")   trava_ponte();
if (PART == "asm_trava_celular") trava_celular();
if (PART == "trava_ponte")   trava_ponte_plana();
if (PART == "trava_celular") {       // calha + 2 cursores + 2 parafusos, prontos para imprimir
    translate([0, -Y_C, -(Z_VB + TC_O)]) calha_celular();
    for (k = [0, 1]) translate([-25 + 50*k, 30, 0]) translate([0, -Y_C, -(Z_VB - CU_B)]) cursor_local();
    for (k = [0, 1]) translate([-10 + 20*k, 62, 0]) translate([0, 0, -(Z_VB - CU_B - CU_GAP - CU_KH)]) paraf_cursor_local();
}
TRV = TC_O + 1.6*sqrt(2);        // a calha da trava lateral levanta o celular (2,4 mm)

// =====================================================================
//  SUPORTE FIXO DO CELULAR (substitui a articulação)
// =====================================================================
// O celular fica num clip de mola, fixo na base do giro da ponte, sem movimento:
//   "Ultimate Desk & Cockpit Phone Holder Clip v3", de RealNationPrint: https://makerworld.com/models/1158094
// O clip é um perfil 2D extrudado. A garra de cima (com a mola em espiral) segura o celular deitado pela
// altura; a garra de baixo, que prendia no painel do carro, sai. No lugar dela entra um pé com furo em D
// que encaixa no pino do giro (não gira) e é apertado por uma porca-botão que rosqueia no pino por cima.
// O perfil do clip NÃO faz parte deste projeto (licença do autor: uso pessoal, sem redistribuição).
// Baixe o .3mf no MakerWorld e rode:  python3 tools/clip_perfil.py ClipV3.3mf
// Isso grava scad/clip_v3_perfil.scad (CLIP_W e CLIP_P). Sem ele, o clip não aparece.
include <clip_v3_perfil.scad>
CLW = is_undef(CLIP_W) ? 27.5 : CLIP_W;      // largura do clip (110 %)
CLP = is_undef(CLIP_P) ? [] : CLIP_P;        // perfil (vazio sem o arquivo gerado)
// coordenadas do perfil do clip (x, y) → montagem: X = extrusão, Y = x + CL_OY, Z = y + CL_OZ
// (+x do perfil = lado da tela = operador; o celular fica de pé, tela para trás)
CL_PX = -7;                      // x do pino do giro no perfil (atrás dos dentes, fora do lugar do celular)
CL_Y0 = -3.2;                    // fundo plano do corpo do clip
CL_FT = 6.5;                     // pé: de Z_PAN até o fundo do corpo
CL_OY = PC - CL_PX;  CL_OZ = Z_PAN + CL_FT - CL_Y0;
CL_X0 = -21;  CL_X1 = 32.5;      // pé: de trás (sobre a base do giro) até a frente (sob o lábio)
CB_Z0 = Z_PAN + 3.5;             // fundo do rebaixo: 3,5 mm de furo em D travam o giro
CB_R = 7;                        // rebaixo da porca-botão
CK_D = 18;  CK_H = 7;  CK_Z0 = CL_OZ + 8;     // botão (acima do corpo, atrás do celular)
PH_CASE = 1.3;                   // capinha (por lado), só para a montagem
CL_INC = 15;                     // inclinação do celular para trás (tela apontando um pouco para cima), graus
CL_XF = 33.5;                    // frente da base reta do pé
module rot_cl() { translate([CL_PX, CL_Y0]) rotate(CL_INC) translate([-CL_PX, -CL_Y0]) children(); }   // pivô: pino do giro
module clip_corpo_2d(p) {        // clip sem a garra de baixo + pé (antes de inclinar)
    intersection() { polygon(p); translate([-100, CL_Y0 + 0.2]) square([200, 100]); }
    polygon([[CL_X0, CL_Y0 - CL_FT - 6], [CL_X1, CL_Y0 - CL_FT - 6], [CL_X1, CL_Y0 + 0.5], [-10, CL_Y0 + 0.5], [CL_X0, CL_Y0 + 3.5]]);
}
module clip_rig_2d(p = CLP) {    // corpo inclinado + base reta apoiada na base do giro
    if (len(p) > 0) intersection() {
        union() {
            rot_cl() clip_corpo_2d(p);
            translate([CL_X0, CL_Y0 - CL_FT]) square([CL_XF - CL_X0, CL_FT + 1.2]);
        }
        translate([-100, CL_Y0 - CL_FT]) square([200, 200]);
    }
}
module clip_rig(p = CLP) {
    difference() {
        translate([0, CL_OY, CL_OZ]) along_x(-CLW/2, CLW/2) clip_rig_2d(p);
        f_giro() {
            // furo em D no pino do giro: a face plana do pino trava o clip (teto reto ao imprimir de lado)
            translate([0, 0, Z_PAN - 1]) linear_extrude(CB_Z0 - Z_PAN + 1.01)
                intersection() { circle(r = TH_D/2 + 0.35, $fn = 40); translate([-10, -10]) square([10 + PIN_FLAT + 0.3, 20]); }
            // rebaixo da porca-botão, em gota (ponta para +X = para cima na impressão)
            translate([0, 0, CB_Z0]) linear_extrude(CK_Z0 - CB_Z0) gota2d(CB_R, 0);
        }
    }
}
// só para a ilustração da montagem: a mola em espiral esticada e a garra de cima em cima do celular
CL_ABRE = 3.6 + PH[1] + 2*PH_CASE - 34;
module clip_aberto() { clip_rig([for (q = CLP) [q[0], q[1] + CL_ABRE*min(1, max(0, (q[1] - 9)/19.5))]]); }
module f_incl_cl() {             // sistema do perfil inclinado (para o celular da montagem)
    translate([0, PC, CL_Y0 + CL_OZ]) rotate([CL_INC, 0, 0]) translate([0, -PC, -(CL_Y0 + CL_OZ)]) children();
}
module porca_clip() {            // porca-botão: rosqueia no pino do giro e aperta o pé do clip na base do giro
    difference() {
        union() {
            translate([0, 0, CB_Z0]) cylinder(r = CB_R - 0.45, h = CK_Z0 - CB_Z0 + 0.01);
            translate([0, 0, CK_Z0]) knob(CK_D, CK_H, 12);
        }
        femea(CB_Z0, PIN_Z1 + 1, true, false);
    }
}
module phone_clip_ref() {        // S21 com capinha no clip: fundo nos dentes, frente atrás do lábio
    t = PH[2] + 2*PH_CASE;  L = PH[0] + 2*PH_CASE;  H = PH[1] + 2*PH_CASE;
    f_incl_cl() translate([-L/2, 24.6 + CL_OY - t, 3.6 + CL_OZ]) cube([L, t, H]);
}
if (PART == "montagem") {
    camera_ref(); powerbank_ref(); easycap_ref();
    color("dimgray") { berco(); topo(); cabo(); tampa(); }
    color("orange") { chave(); trava_ponte(); f_giro() porca_clip(); }
    color("white") clip_aberto();
    color([0.05, 0.05, 0.07]) phone_clip_ref();
}
if (PART == "asm_clip")       clip_rig();
if (PART == "asm_porca_clip") f_giro() porca_clip();
if (PART == "asm_celular_clip") phone_clip_ref();
if (PART == "asm_clip_aberto")  clip_aberto();
// impressão: clip deitado (perfil na mesa, +X para cima: teto reto no furo em D); porca com o botão na mesa
if (PART == "clip")       translate([0, 0, CLW/2]) rotate([-90, 0, 0]) rotate([0, 0, -90]) translate([0, -CL_OY, -CL_OZ]) clip_rig();
if (PART == "porca_clip") translate([0, 0, CK_Z0 + CK_H]) rotate([180, 0, 0]) porca_clip();
