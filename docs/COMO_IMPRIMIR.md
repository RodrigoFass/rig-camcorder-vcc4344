# Como imprimir

As mesas da pasta `mesas/` foram montadas para a **Anycubic Kobra X** (mesa de 260 × 260 mm) e o **Anycubic Slicer Next**, mas abrem em qualquer fatiador que leia `.3mf`. As peças já vêm na posição certa. O material está no nome do arquivo, e no fatiador cada peça aparece como "PETG - …" ou "PLA - …". Em outra impressora, use os STLs da pasta `stl/`: eles já estão na posição de impressão.

| Ordem | Arquivo | Material | Filamento* |
|---|---|---|---|
| 1 | `1a_teste_PLA.3mf` | PLA | ~6 g |
| 1 | `1b_teste_PETG.3mf` | PETG | ~10 g |
| 2 | `2_berco_tampa_PETG.3mf` | PETG | ~75 g |
| 3 | `3_cabo_ponte_chave_PLA.3mf` | PLA | ~40 g |
| 4 | `5_trava_ponte_PETG.3mf` | PETG (ou PLA) | ~6 g |
| 5 | clip do celular + porca-botão ([gere você mesmo](SUPORTE_CLIP.md)) | PETG | ~33 g |

A porca-botão também pode sair sozinha em PLA: `8_porca_clip_PLA.3mf` (~3 g). As mesas `3_cabo_e_articulacao_PLA`, `4_parafusos_PLA` e `6_trava_celular_PLA` são da [versão articulada](ARTICULACAO.md) e não são usadas com o clip.

\* Estimativa. O fatiador mostra o peso exato.

**Por que PETG no berço:** ele tem molas e travas que flexionam e fica encostado na câmera, que esquenta. O PLA amolece por volta de 55 °C e pode ceder.

## Configuração

### Mesas 1a, 1b, 2, 3, 5 e o clip
- **Processo:** 0.20mm Standard (camada de 0,2 mm).
- **Resistência:**
  - 3 paredes;
  - 4 camadas sólidas em cima e embaixo;
  - preenchimento de 15 % em **Giroide**. Evite Grade, que faz o bico raspar nas linhas já impressas.
- **Suporte:** desligado.
- **Borda (brim):** sem borda. A exceção é o cabo, na mesa `3_cabo_ponte_chave`: ligue brim de 5 mm só nele, porque ele imprime em pé. No Anycubic Slicer, clique com o botão direito no cabo e use a aba **Objetos**.
- **Velocidade:** com PETG, deixe a parede externa do berço em ~100 mm/s. As colunas são altas e finas.

A mesa 1a usa a mesma configuração da mesa 3 de propósito: assim a prova da rosca reproduz a rosca do pino da ponte. O clip usa 25 % de preenchimento em vez de 15 %, como no perfil do autor ([veja](SUPORTE_CLIP.md#impressão)).

### Porca-botão sozinha em PLA e mesas 4 e 6 da versão articulada
- Camada de **0,12 mm**
- **5 paredes**
- **40 %** de preenchimento
- Parede externa a ~60 mm/s

### PETG em mesa de PEI liso
Passe cola bastão antes de imprimir. Sem ela, o PETG gruda demais e pode arrancar a película da mesa.

## Provas de encaixe

Imprima as mesas 1a e 1b antes das peças grandes. A tabela com o que conferir e qual parâmetro ajustar está no [README](../README.md#antes-de-imprimir-provas-e-ajustes).
