# Template — Matriz de Permissões e Consentimento (MPC)

## 1. Visão do App

* **Nome do app / pacote**:
* **Funções principais (em 1–3 frases)**:
* **Público-alvo / restrições (Família, Infantil, Saúde, etc.)**:
* **Links de política e store listing coerentes com as permissões**:

## 2. Princípios do Fluxo de Permissões

1. **Função principal → Dado mínimo → Permissão correta → Pedido em contexto → Alternativa digna → Proteção do dado**
2. **Classificação correta**: instalação (normal/assinatura), execução (dangerous), especiais.
3. **Menor intrusão possível** (Photo Picker/SAF/MediaStore, localização aproximada, foreground).
4. **Alinhado às políticas do Google Play** (declarações quando exigidas, uso limitado, consentimento específico).

## 3. Matriz (uma linha por permissão/feature)

| Feature (história do usuário)                  | Permissão                                 | Tipo (normal/dangerous/especial/assinatura) | Dado/Ação acessado(a) | Justificativa (ligada à função principal)                    | Alternativa menos intrusiva | Ponto de pedido (UX)                    | Texto de consentimento (curto e específico)                              | Fallback se negar                     | Retenção/uso/compartilhamento           | Exigências Play Console                  | Responsável   |
| ---------------------------------------------- | ----------------------------------------- | ------------------------------------------- | --------------------- | ------------------------------------------------------------ | --------------------------- | --------------------------------------- | ------------------------------------------------------------------------ | ------------------------------------- | --------------------------------------- | ---------------------------------------- | ------------- |
| Escanear QR agora                              | `CAMERA`                                  | dangerous                                   | Câmera                | Escanear QR para autenticar entrada no evento (feature core) | Photo Picker (imagem do QR) | Ao tocar “Escanear QR”                  | “Precisamos da câmera para escanear seu QR agora.”                       | Selecionar foto do QR                 | Não persiste imagem; só metadados do QR | Não requer formulário                    | Mobile Lead   |
| Selecionar mídia pontual                       | *(nenhuma)*                               | —                                           | —                     | Caso não recorrente; não há acesso amplo                     | **Android Photo Picker**    | Ao tocar “Selecionar foto”              | —                                                                        | Usuário cancela/volta                 | Sem coleta                              | —                                        | Mobile Lead   |
| Localização do mapa durante uso                | `ACCESS_COARSE/FINE_LOCATION` (FG)        | dangerous                                   | Local durante uso     | Mostrar posição atual no mapa (benefício imediato)           | Marcador manual             | Ao abrir “Minha posição”                | “Para mostrar sua posição no mapa, precisamos da sua localização agora.” | Campo para digitar endereço           | Não reter; não compartilhar             | Se houver BG futuramente → declarar      | PO de Produto |
| Geofencing essencial (BG)                      | `ACCESS_BACKGROUND_LOCATION`              | dangerous (BG)                              | Local em 2º plano     | Alerta de segurança do perímetro (core)                      | FG + notificação manual     | Após aprovar FG, fluxo separado para BG | “Para alertas automáticos, precisamos de localização em 2º plano.”       | Desativar alertas ou periodic polling | Retenção mínima (logs agregados)        | **Formulário Play Console** + evidências | PO/Legal      |
| Sobrepor outros apps (bolha de acessibilidade) | **Acesso especial** `SYSTEM_ALERT_WINDOW` | especial                                    | Overlay               | Botão de acessibilidade configurável (core)                  | Notificação de ação         | Tela de configuração do recurso         | “Ative ‘sobrepor’ para mostrar o botão de acesso rápido.”                | Atalho via notificação                | Sem coleta                              | Explicitar no store listing              | Mobile Lead   |
| Gestão ampla de arquivos (evitar)              | `MANAGE_EXTERNAL_STORAGE`                 | altamente restrita                          | Storage amplo         | **Evitar**; não faz parte da função principal                | SAF/MediaStore/Picker       | —                                       | —                                                                        | —                                     | —                                       | **Não usar** (reprova)                   | Arquiteto     |

> Dicas:
>
> * Sempre associe cada permissão a **1 história de usuário** (benefício mensurável).
> * **Texto de consentimento** curto, contextual, sem jargão.
> * **Fallback** implementado antes da publicação.
> * Use a coluna “Exigências Play Console” para marcar se há **formulário de declaração** (p.ex., BG location, SMS/Call Log, All Files).

## 4. Definição de Pronto (DoD) para cada permissão

* [ ] Manifest contém **apenas** as permissões necessárias.
* [ ] **Pedido em contexto** implementado (late ask) + **texto específico**.
* [ ] **Alternativa menos intrusiva** e **fallback** funcionais.
* [ ] **Uso limitado / retenção mínima / revogação pós-tarefa** implementados.
* [ ] **Store listing** e **política de privacidade** revisadas e coerentes.
* [ ] Se aplicável, **formulários do Play Console** enviados com evidências (vídeo/gifs/prints do fluxo).
* [ ] Testes manuais e automáticos (nega/permitir/revogar/em modo avião/em diferentes versões de Android).

## 5. Mensagens de Consentimento (exemplos prontos)

* Câmera: “Precisamos da câmera para **escanear seu QR agora**. Sem ela, você pode **enviar uma foto do QR**.”
* Localização FG: “Para **mostrar sua posição no mapa**, precisamos da sua localização **apenas durante o uso**.”
* Localização BG: “Para **alertas automáticos** sem abrir o app, precisamos da sua **localização em segundo plano**.”
* Overlay: “Para um **botão de acesso rápido** na tela, ative **‘sobrepor outros apps’** nas configurações.”

## 6. Referências (para manter vinculado na MPC)

* Android — visão geral de permissões (tipos e melhores práticas)
* Play Console — Permissões e APIs que acessam informações sensíveis
* Photo Picker / SAF / MediaStore
* Localização FG/BG e exatos alarmes
  *(linkar as páginas oficiais que você já usa no material)*

---

## Schema — YAML (versionável no repositório)

```yaml
app:
  name: ""
  package: ""
  core_functions: ""
  audiences: ""
  store_listing_urls: []
permissions_matrix:
  - feature: "Escanear QR"
    permission: "android.permission.CAMERA"
    type: "dangerous"
    data_or_action: "camera_stream"
    core_justification: "Escanear QR para autenticação"
    less_intrusive_alt: "Android Photo Picker"
    request_trigger: "Ao tocar 'Escanear QR'"
    consent_text: "Precisamos da câmera para escanear seu QR agora."
    fallback: "Selecionar imagem com QR"
    retention_use_share: "Sem retenção de imagem; só metadado do QR"
    play_console_requirements: "none"
    owner: "mobile_lead"
  - feature: "Mapa — minha posição"
    permission: "android.permission.ACCESS_FINE_LOCATION"
    type: "dangerous"
    data_or_action: "location_foreground"
    core_justification: "Mostrar posição atual"
    less_intrusive_alt: "Marcador manual"
    request_trigger: "Ao tocar 'Minha posição'"
    consent_text: "Para mostrar sua posição no mapa, precisamos da sua localização agora."
    fallback: "Digitar endereço"
    retention_use_share: "Não reter; sem compartilhamento"
    play_console_requirements: "none"
    owner: "po_produto"
  - feature: "Alertas automáticos"
    permission: "android.permission.ACCESS_BACKGROUND_LOCATION"
    type: "dangerous_bg"
    data_or_action: "location_background"
    core_justification: "Alerta perimetral essencial"
    less_intrusive_alt: "FG + notificação manual"
    request_trigger: "Fluxo separado após FG"
    consent_text: "Para alertas automáticos, precisamos de localização em 2º plano."
    fallback: "Sem BG; alerta manual"
    retention_use_share: "Mínima; logs agregados"
    play_console_requirements: "declaration_form_required"
    owner: "po_legal"
  - feature: "Botão flutuante"
    permission: "SYSTEM_ALERT_WINDOW"
    type: "special_access"
    data_or_action: "overlay"
    core_justification: "Acesso rápido de acessibilidade"
    less_intrusive_alt: "Atalho por notificação"
    request_trigger: "Tela de configuração do recurso"
    consent_text: "Ative 'sobrepor outros apps' para mostrar o botão flutuante."
    fallback: "Atalho notificação"
    retention_use_share: "—"
    play_console_requirements: "store_listing_disclosure"
    owner: "mobile_lead"
  - feature: "Arquivos amplos (evitar)"
    permission: "MANAGE_EXTERNAL_STORAGE"
    type: "highly_restricted"
    data_or_action: "all_files_access"
    core_justification: "Não essencial; evitar"
    less_intrusive_alt: "SAF/MediaStore/Photo Picker"
    request_trigger: "—"
    consent_text: "—"
    fallback: "—"
    retention_use_share: "—"
    play_console_requirements: "do_not_use"
    owner: "architect"
governance:
  dod_checklist:
    - manifest_minimal
    - contextual_request
    - less_intrusive_alt
    - fallback_ready
    - limited_use_min_retention
    - store_listing_aligned
    - play_console_declarations_done
    - test_matrix_passed
  review_cadence: "cada release"
  approvers:
    - security_lead
    - legal_compliance
    - product_owner
```

# Aula — Permissões no Android com Flutter (dangerous × special × signature)

Este repositório contém um **app de demonstração em Flutter** para ensinar, na prática, as diferenças entre:

* **Dangerous permissions** (permissões de execução)
* **Special permissions** (acesso especial via Configurações)
* **Signature permissions** (protegidas por assinatura; indisponíveis para apps de terceiros)

Além do código, o projeto mostra **como pedir em contexto**, **como oferecer alternativa digna** quando o usuário nega e **como alinhar o fluxo às políticas do Google Play**.

---

## 1) Conceitos essenciais (resumo didático)

* **Dangerous (execução)**: acessam **dados/ações sensíveis** (ex.: `CAMERA`, `RECORD_AUDIO`, `ACCESS_FINE_LOCATION`).
  ⇒ Devem ser **verificadas e solicitadas em tempo de execução**, no **ponto de uso**. Mostram diálogo do sistema.

* **Special (acesso especial)**: não são solicitadas via diálogo padrão. Exigem **navegar para uma tela das Configurações** para o usuário ligar/desligar (ex.: **sobrepor outros apps** `SYSTEM_ALERT_WINDOW`, **exatos alarmes** em Android 14+, **notificação em tela cheia**).
  ⇒ O app precisa **explicar** e **enviar o usuário** para a tela correta.

* **Signature (assinatura)**: só são concedidas se o app estiver **assinado com a mesma chave** que definiu a permissão (sistema/OEM).
  ⇒ Para apps de terceiros (nós), **trate como indisponíveis**. Mostre **apenas didaticamente** que não dá para solicitá-las.

---

## 2) O que o app demonstra

* **Câmera (dangerous)**: botão “Escanear QR” → pede `CAMERA` **no momento do uso**.
  Fallback: “Selecionar imagem com QR” (sem acesso persistente).

* **Localização (dangerous)**: botão “Minha posição” → pede `ACCESS_FINE_LOCATION` **durante o uso**.
  Fallback: digitar endereço manualmente.

* **Sobrepor outros apps (special)**: tela “Botão flutuante” → orienta a ligar **“Sobrepor outros apps”** nas Configurações.
  Fallback: atalho por **notificação**.

* **Permissão de assinatura (signature)**: seção “Permissões de assinatura” explica por que **não é possível** solicitar no app.

---

## 3) Estrutura dos arquivos principais

```
lib/
  main.dart             # UI simples com botões para cada caso + mensagens de consentimento claras
android/app/src/main/
  AndroidManifest.xml   # Declara as permissões dangerous, intents e queries
```

> Obs.: Em **special permissions**, não há `uses-permission` clássico — o fluxo abre a **tela do sistema** correspondente.

---

## 4) Como executar

1. **Pré-requisitos**

   * Flutter 3.x+ instalado (`flutter doctor`)
   * Android SDK atualizado (compile/target 34 ou 35)
   * Emulador Android 13+ **ou** dispositivo físico

2. **Instalar dependências e rodar**

   ```bash
   flutter pub get
   flutter run
   ```

3. **Testar os fluxos**

   * Toque em **“Escanear QR”** → aceite/negue a câmera e observe o fallback.
   * Toque em **“Minha posição”** → aceite/negue a localização e teste o fallback.
   * Toque em **“Botão flutuante”** → siga para **Configurações** e habilite **Sobrepor outros apps**.

---

## 5) AndroidManifest.xml — pontos importantes

* **Dangerous** (declaração + runtime):

  ```xml
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  ```

* **Queries** (visibilidade de pacotes para intents específicas — usado pelo engine Flutter p/ Process Text):

  ```xml
  <queries>
    <intent>
      <action android:name="android.intent.action.PROCESS_TEXT"/>
      <data android:mimeType="text/plain"/>
    </intent>
  </queries>
  ```

* **Special**: não é `uses-permission` clássico; você **navega para a tela do sistema** (o app mostra o fluxo didático).

> Dica: Em Android 13+, acesso a mídia é granular (`READ_MEDIA_IMAGES`/`READ_MEDIA_VIDEO`); use **Photo Picker** quando possível para **evitar** pedir permissões.

---

## 6) Boas práticas de UX de consentimento (o app aplica)

* **Texto específico e contextual**:
  “Precisamos da câmera **para escanear seu QR agora**” (não genérico).
* **Pedido tardio** (“late ask”): só quando o usuário toca na ação.
* **Alternativa digna**: se negar, **continua possível** (talvez com mais passos).
* **Indicadores**: se o sistema não indicar uso de câmera/mic, o app deixa claro.

---

## 7) Alinhamento com políticas do Google Play (checklist)

* [x] **Função principal** explícita para cada permissão.
* [x] **Uso limitado** e **dados mínimos**; nada de reuso para ads/analytics fora do escopo consentido.
* [x] **Alternativas** implementadas para negação (ex.: seletor/foto/entrada manual).
* [x] **Declarações no Play Console** se/quando aplicável (ex.: localização em segundo plano, “All files”).
* [x] **Store listing/coerência**: descrição do app condiz com as permissões.

> Para publicar apps reais, mantenha uma **Matriz de Permissões e Consentimento (MPC)** no repositório com: feature → permissão → justificativa → pedido em contexto → fallback → retenção/uso/compartilhamento → requisitos do Play Console.

---

## 8) Como o código ilustra cada tipo

### 8.1 Dangerous (runtime)

* Verifica com `checkPermission` (ou API nativa via channel).
* Se **negado**, mostra **rationale** claro e pede novamente **no contexto**.
* Se **negado de novo**, oferece **fallback** (sem bloquear a jornada).

### 8.2 Special (acesso especial)

* Abre **Settings** apropriado com `Intent(android.settings.ACTION_MANAGE_OVERLAY_PERMISSION, packageUri)`.
* Explica **o porquê** e **o que muda** se o usuário não ativar.
* Oferece **modo alternativo** (notificação/atalho) se o usuário não quiser habilitar.

### 8.3 Signature

* Mostra **cartão informativo**: são permissões de **nível de plataforma/OEM**, indisponíveis para apps comuns.
* Discute exemplos (VPN service binding, autofill service binding) **sem tentar solicitar**.

---

## 9) Testes sugeridos (manual e automatizado)

* **Primeiro uso**: negar tudo → confirmar que os **fallbacks** funcionam e o app **não quebra**.
* **Conceder e revogar**: conceda, use a feature, depois **revogue em Settings** e repita.
* **Várias versões**: Android 12/13/14/15 para ver diferenças (Photo Picker, mídia granular, exatos alarmes).
* **Mudança de orientação e background/foreground**: preservar estado do pedido.
* **Sem rede**: o app deve **degradar com dignidade**.

---

## 10) Solução de problemas (FAQ)

* **“O diálogo de permissão não aparece”**
  Verifique se a permissão está **declarada no Manifest** e se você está **pedindo em runtime** (para dangerous).
  Em **special**, confirme se está chamando a **Intent de Settings** correta.

* **“A loja reprovou meu app por ‘permissões desnecessárias’”**
  Garanta que a permissão está **vinculada à função principal** e que existe **fluxo de uso claro** no app.
  **Remova** o que não for essencial e **atualize** o store listing.

* **“Quero ler todas as fotos, mas é uso eventual”**
  Use o **Android Photo Picker** (evita pedir `READ_MEDIA_*`). Explique didaticamente no app.

---

## 11) Referências oficiais (estude com seus alunos)

* **Visão geral de permissões (Android Developers)**
  [https://developer.android.com/guide/topics/permissions/overview?hl=pt-br](https://developer.android.com/guide/topics/permissions/overview?hl=pt-br)

* **Política do Google Play — Permissões e APIs sensíveis**
  [https://support.google.com/googleplay/android-developer/answer/16558241?hl=pt-br](https://support.google.com/googleplay/android-developer/answer/16558241?hl=pt-br)

* **Seletor de fotos do Android (reduz escopo)**
  [https://developer.android.com/training/data-storage/shared/photo-picker?hl=pt-br](https://developer.android.com/training/data-storage/shared/photo-picker?hl=pt-br)

* **Permissões de localização (FG/BG)**
  [https://developer.android.com/develop/sensors-and-location/location/permissions](https://developer.android.com/develop/sensors-and-location/location/permissions)

* **Alarmes exatos — mudanças Android 14+**
  [https://developer.android.com/about/versions/14/changes/schedule-exact-alarms?hl=pt-br](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms?hl=pt-br)

---

# Manifest

Em projetos Android (incluindo Flutter), você pode ter **vários AndroidManifest.xml** dentro de `app/src/*`. Eles pertencem a **source sets** (conjuntos de fonte) e são **mesclados** pelo Gradle no build final. A ideia é: você tem um manifesto “base” e pode **sobrepor/ajustar** por tipo de build (debug/release), por *flavor* (ex.: free/prod), ou por variação (debug de um flavor, etc.).

# Onde ficam e para que servem

* `app/src/main/AndroidManifest.xml`
  “Manifesto base” — vale para **todas** as variantes. Defina aqui **quase tudo**: activities, services, provider, permissões comuns, *intent-filters*, *meta-data*.

* `app/src/debug/AndroidManifest.xml`
  Ajustes **só para build debug**. Ex.: `android:usesCleartextTraffic="true"`, permissões temporárias (ex.: `INTERNET` em apps que só precisam no debug), *provider* de debug, *tools:replace* para trocar algum atributo em debug.

* `app/src/release/AndroidManifest.xml`
  Ajustes **só para build release**. Ex.: desabilitar um *provider* de debug, forçar `android:debuggable="false"` (embora o Gradle já faça), alterar *networkSecurityConfig*, metas de analytics habilitadas só no release.

* `app/src/profile/AndroidManifest.xml` (Flutter)
  Usado no modo **profile** (otimizado, com *tracing*). Pode conter configs específicas para perf/perfis.

* `app/src/<flavor>/AndroidManifest.xml` (se você usa *product flavors*)
  Ajustes por **variante de produto**. Ex.: `free/AndroidManifest.xml` vs `paid/AndroidManifest.xml` — mudando *authority* de `FileProvider`, *deep links*, *meta-data* de chave, *label* do app, etc.

* `lib`/dependências AAR também têm seus manifestos
  Eles entram na **fusão** (merge) automaticamente, podendo adicionar *providers*, *meta-data* (como o de Firebase), permissões sugeridas, etc.

# Como funciona a “fusão” (manifest merge)

O Gradle cria **um manifesto final** combinando tudo. A **prioridade** (o que “ganha” em conflito) é aproximadamente:

1. **Manifests da variante mais específica**
   (ex.: `src/freeDebug/AndroidManifest.xml`, se existir)
2. **Manifest do build type**
   (`src/debug/AndroidManifest.xml` ou `src/release/AndroidManifest.xml`)
3. **Manifest do flavor**
   (`src/free/AndroidManifest.xml`, `src/pro/AndroidManifest.xml`, etc.)
4. **Manifest base**
   (`src/main/AndroidManifest.xml`)
5. **Manifests de bibliotecas/dependências**
   (AARs, transitive)

Para controlar conflitos, use o namespace `tools:` no elemento afetado:

```xml
<application
    tools:replace="android:usesCleartextTraffic"
    android:usesCleartextTraffic="true" />
```

> Dica: habilite o *Manifest Merger report* (Android Studio > Merged Manifest) para ver de onde veio cada nó/atributo.

# O que colocar em cada um (regra prática)

* **`main/`**: tudo que é perene (activities, *intent-filters*, permissões comuns, *FileProvider*, *Deep Links*).
* **`debug/`**: coisas só de desenvolvimento:

  * `usesCleartextTraffic="true"`;
  * permissões temporárias (ex.: localização/câmera “didáticas”);
  * *meta-data* para Stetho/LeakCanary;
  * desabilitar *crash reporting* real.
* **`release/`**: *toggles* de produção:

  * reforçar políticas de rede;
  * *meta-data* de analytics reais;
  * remover componentes de debug.
* **`<flavor>/`**: diferenças entre edições do app:

  * `applicationIdSuffix`, *authority* de `FileProvider`, *intent-filters* específicos, *meta-data* de chaves (ex.: endpoints *free* vs *pro*).
* **`profile/`** (Flutter): ajustes de perf/trace.

# Exemplos rápidos

### 1) `src/main/AndroidManifest.xml` (base)

```xml
<manifest package="com.exemplo.app" xmlns:android="http://schemas.android.com/apk/res/android">
  <application
      android:name=".App"
      android:label="@string/app_name"
      android:icon="@mipmap/ic_launcher">
    <activity
        android:name=".MainActivity"
        android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
      </intent-filter>
    </activity>
  </application>

  <!-- Permissões comuns -->
  <uses-permission android:name="android.permission.INTERNET" />
</manifest>
```

### 2) `src/debug/AndroidManifest.xml` (só no debug)

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools">
  <application
      tools:replace="android:usesCleartextTraffic"
      android:usesCleartextTraffic="true">

    <!-- Meta de uma lib de debug -->
    <meta-data android:name="com.exemplo.DEBUG_ENABLED" android:value="true" />
  </application>
</manifest>
```

### 3) `src/release/AndroidManifest.xml` (só no release)

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools">
  <application
      tools:replace="android:usesCleartextTraffic"
      android:usesCleartextTraffic="false">
    <!-- Meta de analytics em produção -->
    <meta-data android:name="com.analytics.API_KEY" android:value="@string/analytics_key_prod" />
  </application>
</manifest>
```

### 4) `src/free/AndroidManifest.xml` (flavor “free”)

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <application android:label="@string/app_name_free">
    <!-- Deep link só na edição free -->
    <activity android:name=".PromoActivity">
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" android:host="free.exemplo.com" android:pathPrefix="/promo" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

# Perguntas comuns

**Onde coloco permissões (uses-permission)?**
No **`main`** quando forem usadas por todo o app. Se a permissão existir **só em debug**, declare em `debug/`. Para flavors diferentes, declare no *flavor* correspondente.

**E se a lib que uso adiciona coisas no manifesto?**
Vai entrar no *merge*. Se conflitar com o seu, resolva com `tools:replace`/`tools:node="remove|merge|replace"`, ou mova a definição para o manifesto de **maior prioridade** (debug/flavor).

**Como vejo o resultado final?**
No Android Studio, abra o **Merged Manifest** (aba do editor) — mostra a árvore final e a origem de cada nó.
---