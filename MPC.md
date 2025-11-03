# Matriz de Permissões e Consentimento (MPC)

> Documento vivo. Versione este arquivo e associe cada mudança de permissão a um PR.

## 1. Visão do App
- **Nome do app / pacote**: Aula de Permissões / `br.techcoop.aula_permissoes`
- **Funções principais (1–3 frases)**: Demonstra fluxos de consentimento no Android (Flutter) para câmera (QR), localização durante uso (mapa), “sobrepor outros apps” (botão flutuante) e exemplos didáticos de permissões de assinatura.
- **Público-alvo**: Estudantes/educadores (não direcionado a crianças).
- **Store listing / Política de privacidade**: Ajustar conforme publicação real. Este projeto é didático.

## 2. Princípios do Fluxo de Permissões
1) **Função principal → Dado mínimo → Permissão correta → Pedido em contexto → Alternativa digna → Proteção do dado**.  
2) **Classificação correta**: instalação (normal/assinatura), execução (dangerous), especiais.  
3) **Menor intrusão possível**: Photo Picker/SAF/MediaStore; localização aproximada + foreground.  
4) **Alinhado ao Google Play**: uso limitado, consentimento específico, declarações quando exigidas.

## 3. Matriz (uma linha por permissão/feature)

| Feature (história do usuário) | Permissão | Tipo | Dado/Ação | Justificativa (ligada à função principal) | Alternativa menos intrusiva | Ponto de pedido (UX) | Texto de consentimento (curto) | Fallback se negar | Retenção/uso/compartilhamento | Exigências Play Console | Responsável |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Escanear QR agora | `android.permission.CAMERA` | dangerous | Câmera | Escanear QR para autenticar entrada no evento (core) | Photo Picker (imagem do QR) | Ao tocar “Escanear QR” | “Precisamos da câmera para escanear seu QR agora.” | Selecionar foto do QR | Não persiste imagem; só metadados do QR | — | Mobile Lead |
| Minha posição no mapa | `android.permission.ACCESS_FINE_LOCATION` | dangerous (FG) | Local durante uso | Mostrar posição atual no mapa (benefício imediato) | Marcador manual | Ao tocar “Minha posição” | “Para mostrar sua posição no mapa, precisamos da sua localização agora.” | Digitar endereço | Não reter; não compartilhar | — | PO Produto |
| Botão flutuante (overlay) | **Acesso especial** `SYSTEM_ALERT_WINDOW` | special | Overlay | Acesso rápido de acessibilidade (core didático) | Atalho por notificação | Tela de configuração do recurso | “Ative ‘sobrepor outros apps’ para mostrar o botão flutuante.” | Atalho por notificação | — | Store listing com disclosure | Mobile Lead |
| Exatos alarmes (somente se core) | `USE_EXACT_ALARM` / `SCHEDULE_EXACT_ALARM` | special | Alarmes precisos | Só se alarme/timer/calendário for função principal | Agendamento menos exato | Ao criar alarme | “Para alertas no horário exato, precisamos de alarme exato.” | Agendar janela aproximada | Sem retenção | Declaração se aplicável | Arquiteto |
| Gestão ampla de arquivos (evitar) | `MANAGE_EXTERNAL_STORAGE` | altamente restrita | All files | **Evitar**; não faz parte da função principal | SAF/MediaStore/Photo Picker | — | — | — | — | **Não usar** (reprova) | Arquiteto |
| BG Location (apenas se essencial) | `ACCESS_BACKGROUND_LOCATION` | dangerous (BG) | Local em 2º plano | Geofencing essencial (se core) | FG + notificação manual | Fluxo separado após FG | “Para alertas automáticos, precisamos de local em 2º plano.” | Sem BG; alerta manual | Mínima; agregada | **Formulário Play Console** | PO/Legal |
| Assinatura (didático) | `signature`-level (ex.: binds de serviços) | signature | — | Indisponível para apps de terceiros (exemplos ilustrativos) | — | — | — | — | — | — | Instrutor |

> **Regra de ouro**: cada linha deve mapear “benefício imediato visível para o usuário” e conter *fallback* acionável.

## 4. Definição de Pronto (DoD) por permissão
- [ ] Manifest **mínimo** (somente o necessário).  
- [ ] **Pedido em contexto** implementado + texto específico.  
- [ ] **Alternativa menos intrusiva** e **fallback** funcionais.  
- [ ] **Uso limitado / retenção mínima / revogação** pós-tarefa.  
- [ ] **Store listing** e **política de privacidade** coerentes.  
- [ ] **Declarações Play Console** (quando exigido) com evidências.  
- [ ] **Testes**: permitir/negado/revogado; Android 12–15; offline/background.

## 5. Mensagens de consentimento (exemplos)
- **Câmera**: “Precisamos da câmera para **escanear seu QR agora**. Sem ela, você pode **enviar uma foto do QR**.”  
- **Local (FG)**: “Para **mostrar sua posição no mapa**, precisamos da sua localização **apenas durante o uso**.”  
- **Local (BG)**: “Para **alertas automáticos**, precisamos da sua **localização em segundo plano**.”  
- **Overlay**: “Para um **botão de acesso rápido** na tela, ative **‘sobrepor outros apps’** nas Configurações.”  

## 6. Governança
- **Periodicidade de revisão**: a cada release.  
- **Aprovadores**: Security Lead, Legal/Compliance, Product Owner.

## 7. Referências
- Android — visão geral de permissões: https://developer.android.com/guide/topics/permissions/overview?hl=pt-br  
- Play — Permissões e APIs que acessam informações sensíveis: https://support.google.com/googleplay/android-developer/answer/16558241?hl=pt-br  
- Photo Picker / SAF / MediaStore: https://developer.android.com/training/data-storage/shared/photo-picker?hl=pt-br  
- Localização FG/BG: https://developer.android.com/develop/sensors-and-location/location/permissions  
- Alarmes exatos (Android 14+): https://developer.android.com/about/versions/14/changes/schedule-exact-alarms?hl=pt-br
