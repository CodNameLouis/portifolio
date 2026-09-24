# Portfólio Luan Nunes — Flutter

App de portfólio pessoal (iOS, Android e Web) construído a partir do design "Portfólio — Luan Nunes" (5 telas, 390×844).
Este arquivo é a única fonte de documentação do projeto. **O código não contém comentários de nenhum tipo.**

---

## 0. Status atual (atualizar ao fim de cada fase)

**Atualizado em 24/09/2026, madrugada. Site no ar; iOS enviado à Apple.**

- **Onde estamos:** Fases 0 a 9 concluídas, site Web (seção 6.6) construído e **publicado em https://luan.lumily.com.br**. O **IPA já subiu para o App Store Connect** (build 1.0.0+1). Falta enviar para revisão da Apple e subir o AAB na Play.
- `flutter analyze` limpo, 145 testes verdes, zero comentários em `lib/` e `test/`.

### Retomar por aqui

1. **App Store Connect:** o build já está lá. Falta preencher o que resta da ficha e enviar para revisão.
2. **Play Console:** subir o AAB e abrir o teste fechado. A Play exige **12 testadores por 14 dias seguidos** antes de liberar a produção para conta pessoal nova — é esse o prazo que manda no cronograma, não o build.
3. **A versão subiu para 1.0.0+2.** O `+1` foi consumido pelo envio à Apple; regerar os binários antes de qualquer envio novo.
4. Material de loja e o que ainda falta preencher estão na **Fase 10** e na **seção 13**.

### Duas coisas que não são óbvias no código

- **Web e app são interfaces diferentes.** `kIsWeb` decide: Web → site de página única (`features/site/`), iOS/Android → shell de 5 abas. Mexer numa tela do app não muda o site, e vice-versa. O que é compartilhado são os models, repositórios e Blocs.
- **Conteúdo mora em `assets/data/*.json`**, não no código. Mudar ordem, texto ou rótulo é editar JSON — vale para as duas interfaces de uma vez.

- **Fonte dos textos:** `assets/docs/curriculo_luan_nunes.pdf` + os designs em `docs/design/` e `assets/*-html.zip`.

---

## 1. Regras inegociáveis

1. **Zero comentários no código.** Nada de `//`, `///`, `/* */`, `TODO`, `FIXME` em `lib/` e `test/`. Toda explicação vive aqui.
   - Consequência: não usamos geradores de código (freezed, json_serializable, build_runner), pois os arquivos gerados trazem comentários. Models com `fromJson` manual + `Equatable`.
2. **BLoC como gerenciador de estado** (`flutter_bloc`), sempre `Bloc<Event, State>` com eventos. Sem Cubit, sem setState para estado de negócio.
3. **MVC por feature:** cada feature tem `models/`, `controllers/`, `views/`.
4. **Widgets extraídos:** nenhum método `_buildX()` retornando Widget. Todo pedaço visual vira classe própria em arquivo próprio.
5. **Pasta compartilhada:** widget usado por 2+ features vai para `lib/shared/widgets/`. Usado por uma só fica em `features/<feature>/views/widgets/`.
6. **Sem valores mágicos em widgets:** cores, tamanhos, espaçamentos, raios, fontes e textos vêm de `core/theme` e `core/constants`.
7. **Um widget público por arquivo.** Nome do arquivo = nome da classe em snake_case.
8. Imports sempre `package:portfolio_luan/...` (sem imports relativos).
9. `const` em tudo que puder. `StatelessWidget` por padrão.

---

## 2. Decisões de arquitetura

| Tema | Decisão |
|---|---|
| Plataformas | iOS, Android e Web (mesma base de dados e lógica, **duas interfaces**) |
| Web × mobile | `kIsWeb` decide: na Web roda o **site** (página única com header, seções e rodapé, design `Site · desktop`); no iOS/Android roda o **app** (shell de 5 abas, design 390×844). Models, repositórios e Blocs são os mesmos nos dois |
| Estado | `flutter_bloc` + `equatable`, Bloc com eventos e estados `sealed` |
| Organização | Feature-first com MVC interno + `core/` + `shared/` |
| Dados | JSON local em `assets/data/`, lido por repositórios |
| Troca futura de fonte | Repositório abstrato + implementação `Local...`. Para migrar p/ Supabase basta criar `Supabase...Repository`, sem tocar em Blocs/Views |
| Navegação | `go_router` com `StatefulShellRoute.indexedStack` (5 abas, preserva estado, URLs reais na Web) |
| Injeção de dependência | `MultiRepositoryProvider` no `App`; `BlocProvider` no builder de cada rota |
| Links externos | `url_launcher` encapsulado em `LinkLauncher` (core/services) |
| Ícones | SVGs do design em `assets/icons/`, renderizados com `flutter_svg` |
| Fontes | Bricolage Grotesque (display) e Geist (texto) empacotadas em `assets/fonts/` (funciona offline e idêntico na Web) |
| Serialização | `fromJson` manual (ver regra 1) |
| Ícone e splash | `flutter_launcher_icons` e `flutter_native_splash` (dev deps). Não conflitam com a regra 1: geram PNG/XML/plist, nenhum arquivo Dart |

### Como o MVC se encaixa com BLoC

- **Model** → `models/` (entidades imutáveis) + `repositories/` (acesso a dados). Repositório é parte da camada Model.
- **Controller** → `controllers/` = Bloc, Events e States. Recebe eventos da View, consulta o repositório, emite estados.
- **View** → `views/` = Page (conecta com o Bloc via `BlocProvider`/`BlocBuilder`) + `widgets/` (burros: recebem dados por construtor, nunca leem Bloc).

Fluxo: `View --evento--> Controller(Bloc) --chama--> Repository --lê--> JSON` e volta `Model --estado--> View`.

Só a **Page** conhece o Bloc. Widgets de feature e shared recebem dados e callbacks prontos.

---

## 3. Estrutura de pastas

```
lib/
  main.dart
  app/
    app.dart                          MaterialApp.router + MultiRepositoryProvider + tema
    router/
      app_router.dart                 GoRouter + StatefulShellRoute
      app_routes.dart                 paths e nomes das rotas
    shell/
      views/
        app_shell_page.dart           Scaffold comum: fundo animado + conteúdo + BottomNavBar
  core/
    theme/
      app_colors.dart
      app_typography.dart
      app_spacing.dart
      app_radius.dart
      app_theme.dart                  ThemeData
      app_sizes.dart                  alturas/larguras fixas (nav 68, pill 52, chip 30, ícones 18/22…)
      site_typography.dart            escala tipográfica do site (hero 96, seção 72, contato 88…)
      site_metrics.dart               medidas do site (gutter 80, máx. 1440, breakpoints)
      screen_palette.dart             paleta por tela (claro / escuro / destaque)
    constants/
      app_assets.dart                 caminhos de json, ícones, imagens, fontes
      app_strings.dart                textos fixos de UI
      app_durations.dart
    services/
      json_asset_loader.dart          wrapper do AssetBundle
      link_launcher.dart              wrapper do url_launcher
    errors/
      app_failure.dart
    extensions/
      context_extensions.dart
  shared/
    widgets/
      brand/        logo_badge.dart
      layout/       responsive_frame.dart, page_header.dart, page_title.dart, divided_column.dart,
                    fade_slide_in.dart
      navigation/   bottom_nav_bar.dart, bottom_nav_item.dart, nav_destination.dart
      buttons/      primary_pill_button.dart, outline_pill_button.dart, circle_arrow_button.dart
      chips/        tag_chip.dart, filter_pill.dart, badge_pill.dart, status_pill.dart
      icons/        app_icon.dart, app_icon_type.dart
      feedback/     loading_view.dart, error_view.dart
  features/
    home/
      models/        profile_model.dart, highlight_stat_model.dart
      repositories/  profile_repository.dart, local_profile_repository.dart
      controllers/   home_bloc.dart, home_event.dart, home_state.dart
      views/
        home_page.dart
        widgets/     home_greeting.dart, home_name_title.dart, profile_photo_card.dart,
                     highlight_stats_list.dart, highlight_stat_item.dart, home_actions.dart
    projects/
      models/        project_model.dart, project_category.dart
      repositories/  projects_repository.dart, local_projects_repository.dart
      controllers/   projects_bloc.dart, projects_event.dart, projects_state.dart
      views/
        projects_page.dart
        widgets/     project_filter_bar.dart, featured_project_card.dart, phone_mockup.dart,
                     project_list_tile.dart, project_thumbnail.dart
    stack/
      models/        stack_model.dart, skill_group_model.dart
      repositories/  stack_repository.dart, local_stack_repository.dart
      controllers/   stack_bloc.dart, stack_event.dart, stack_state.dart
      views/
        stack_page.dart
        widgets/     stack_highlight_card.dart, skill_group_row.dart
    trajectory/
      models/        experience_model.dart, education_model.dart, trajectory_model.dart
      repositories/  trajectory_repository.dart, local_trajectory_repository.dart
      controllers/   trajectory_bloc.dart, trajectory_event.dart, trajectory_state.dart
      views/
        trajectory_page.dart
        widgets/     timeline_list.dart, timeline_item.dart, timeline_dot.dart, education_card.dart
    site/                             (só Web) interface de site, consome os Blocs das outras features
      views/
        site_page.dart                página única: header + seções + rodapé, rolagem por âncora
        site_anchor.dart              as 4 âncoras e seus paths
        widgets/     site_header.dart, site_nav_link.dart, site_hero.dart, site_photo_card.dart,
                     site_stats.dart, site_section.dart, site_section_heading.dart,
                     site_pill_button.dart, site_projects_section.dart, site_featured_project.dart,
                     site_project_tile.dart, site_phone_mockup.dart, site_stack_section.dart,
                     site_trajectory_section.dart, site_contact_section.dart, site_footer.dart
    contact/
      models/        contact_model.dart, contact_link_model.dart, contact_link_type.dart
      repositories/  contact_repository.dart, local_contact_repository.dart
      controllers/   contact_bloc.dart, contact_event.dart, contact_state.dart
      views/
        contact_page.dart
        widgets/     contact_hero.dart, contact_link_tile.dart, resume_button.dart

assets/
  data/     profile.json, projects.json, stack.json, trajectory.json, contact.json
  fonts/    BricolageGrotesque-SemiBold/Bold/ExtraBold.ttf, Geist-Regular/Medium/SemiBold.ttf,
            OFL-BricolageGrotesque.txt, OFL-Geist.txt (licenças exigidas pela OFL)
  icons/    home.svg, grid.svg, layers.svg, route.svg, message.svg,
            arrow_right.svg, arrow_up_right.svg, download.svg
  images/   profile.jpg, projects/<id>_thumb.png, projects/<id>_screen.png
  branding/ icon.png (1024, fundo sandLight), icon_foreground.png (adaptativo Android),
            splash.png (marca em 512, fundo transparente)
  Marca-selection.png, Splash-html.zip, "Site · desktop-html.zip"
            artes e designs entregues pelo Luan (fonte, não usados em runtime)

test/       espelha lib/ (mesmos caminhos, sufixo _test.dart)

integration_test/
  screenshots_test.dart             automação das capturas de loja (Fase 10)
test_driver/
  screenshots.dart                  driver que grava os PNGs em screenshots/

screenshots/  android-phone/, iphone-6.9/, ipad-13/ — 5 capturas cada, para as fichas de loja
loja/         icone-512.png, grafico-recursos-1024x500.png — arte da ficha da Play

docs/
  design/   01_inicio.html ... 05_contato.html (referência visual, não é código do app)
```

---

## 4. Design system (extraído do HTML)

### Cores — `AppColors`

| Token | Hex | Uso |
|---|---|---|
| `sand` | `#E6DAB8` | fundo das telas claras, texto em telas escuras |
| `sandLight` | `#EFE6CC` | fundo do pill "Disponível agora" |
| `navy` | `#1E3441` | texto principal, bottom nav, fundo da Trajetória, cards escuros |
| `navyDeep` | `#16272F` | bottom nav e card "Formação" na Trajetória |
| `terracotta` | `#C2462F` | primária: botão CTA, card destaque, fundo do Contato, ponto "disponível" |
| `mustard` | `#E8BE5E` | acento: badges, item ativo da nav, datas da timeline, círculo da foto |
| `slate` | `#4A585D` | texto secundário sobre `sand` |
| `beige` | `#C9BFA3` | texto secundário sobre `navy` |
| `mutedGray` | `#9FA9A8` | ícones/labels inativos da nav |
| `white` | `#FFFFFF` | texto sobre `terracotta` |

Bordas/divisores (alpha sobre a cor de texto da tela): `navy` 16%, 18%, 20%, 25%, 28%; `white` 32%; linha da timeline `mustard` 35%; halo do dot ativo `terracotta` 30%.
Na Trajetória o divisor segue a mesma regra (texto da tela a 18%), o que dá `sand` 18% — token `sandAlpha18`, o único alpha que não aparece explícito no HTML do design.

### Tipografia — `AppTypography`

Display = **Bricolage Grotesque**, Texto = **Geist**.

| Token | Fonte | Tam / altura / tracking | Peso | Onde |
|---|---|---|---|---|
| `heroName` | Bricolage | 60 / 0.92 / -0.035em | 700 | nome na Início |
| `contactTitle` | Bricolage | 46 / 0.98 / -0.03em | 700 | "Vamos tirar seu app do papel?" |
| `pageTitle` | Bricolage | 44 / 1.0 / -0.03em | 700 | títulos de Projetos, Stack, Trajetória |
| `headline` | Bricolage | 26 / 1.05 / -0.02em | 700 | card destaque, "Flutter & Dart", "4+ anos" |
| `title` | Bricolage | 21 / 1.15 / -0.015em | 600 | cargos da timeline |
| `itemTitle` | Bricolage | 18 / — / -0.01em | 600 | nome do app na lista, valor do contato |
| `logo` | Bricolage | 16 / — / -0.02em | 800 | "LN" |
| `bodyLarge` | Geist | 16 / 1.5 | 400 | bio da Início |
| `subtitle` | Geist | 15 / 1.45 | 400 | subtítulos das páginas |
| `button` | Geist | 15 | 600 | botões pill |
| `body` | Geist | 14 / 1.4 | 400 | descrições (card destaque) |
| `bodyTall` | Geist | 14 / 1.45 | 400 | descrições da timeline |
| `bodyStrong` | Geist | 14 / 1.35 | 600 | títulos dos stats |
| `caption` / `captionMedium` / `captionStrong` | Geist | 13 | 400 / 500 / 600 | tags, labels, datas |
| `badge` | Geist | 12 | 600 | "Destaque", "Especialista" |
| `navLabel` / `navLabelActive` | Geist | 11 | 500 (inativo) / 600 (ativo) | bottom nav |

Os pesos que a seção lista como "400/500/600" viram tokens separados (`captionMedium`, `navLabelActive`…) para que nenhum widget precise de `copyWith(fontWeight:)` — regra 6.

### Espaçamento — `AppSpacing`
`xxs 2, xs 4, sm 6, s 8, m 10, md 12, lg 14, xl 16, xxl 18, x3l 20, x4l 22, x5l 24, x6l 28`.
Padding horizontal de página: **24**. Margem horizontal de cards e nav: **16**.

### Raios — `AppRadius`
Pill = metade da altura (`StadiumBorder`). Cards: `28` (destaque), `24` (stack highlight), `22` (formação), `18` (thumbnail). Foto: `79/79/20/20`. Mockup de celular: externo `30`, tela `24`.

### Paleta por tela — `ScreenPalette`
O shell anima o fundo ao trocar de aba (`AnimatedContainer`, 300ms) e ajusta a status bar.

| Tela | Fundo | Texto | Texto 2º | Logo (fundo/texto) | Nav | Status bar |
|---|---|---|---|---|---|---|
| Início, Projetos, Stack | `sand` | `navy` | `slate` | `navy`/`sand` | `navy` | ícones escuros |
| Trajetória | `navy` | `sand` | `beige` | `sand`/`navy` | `navyDeep` | ícones claros |
| Contato | `terracotta` | `white` | `white` | `sand`/`navy` | `navy` | ícones claros |

### Ícones (stroke 1.8 na nav, 2 nos botões, viewBox 24)

| Arquivo | Path |
|---|---|
| `home.svg` | `M3 11l9-7 9 7v9a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z` |
| `grid.svg` | 4× `rect` 7×7 rx 1.5 em (3,3) (14,3) (3,14) (14,14) |
| `layers.svg` | `M12 3l9 5-9 5-9-5z` + `M3 13l9 5 9-5` |
| `route.svg` | `circle(6,6,r2.5)` + `circle(18,18,r2.5)` + `M8.5 6H15a3 3 0 0 1 0 6H9a3 3 0 0 0 0 6h6.5` |
| `message.svg` | `M4 5h16v11H8l-4 4z` |
| `arrow_right.svg` | `M5 12h14` + `M13 6l6 6-6 6` |
| `arrow_up_right.svg` | `M7 17L17 7` + `M8 7h9v9` |
| `download.svg` | `M12 4v12` + `M6 11l6 6 6-6` + `M5 20h14` |

Cor aplicada via `ColorFilter` no `AppIcon`, então os SVGs usam `stroke="currentColor"`.

---

## 5. Widgets compartilhados (`lib/shared/widgets`)

| Widget | Aparece em | Descrição |
|---|---|---|
| `LogoBadge` | todas | círculo 44 "LN"; cores vêm da `ScreenPalette`; toque leva à Início |
| `PageHeader` | todas | linha com `LogoBadge` à esquerda e `trailing` opcional (Início usa `StatusPill`) |
| `PageTitle` | Projetos, Stack, Trajetória | título 44 + subtítulo |
| `ResponsiveFrame` | shell | limita largura em 480 e centraliza na Web/tablet |
| `DividedColumn` | Início, Projetos, Stack, Contato | lista vertical com borda superior entre itens. Params: `dividerColor`, `itemPadding` (todos os itens), `spacingAbove` (folga acima da linha) e `spacingBelow` (folga abaixo, só nos itens divididos). Projetos/Contato usam `itemPadding` vertical 14; Stack, 12; Início usa `spacingAbove` 14 + `spacingBelow` 12 |
| `BottomNavBar` + `BottomNavItem` | shell | pill flutuante 68, margem 16/20; ativo = ponto 4px + ícone mostarda + label `sand` 600 |
| `PrimaryPillButton` | Início, Contato | pill 52, ícone opcional à esquerda/direita, cores parametrizáveis |
| `OutlinePillButton` | Início | pill 52 com borda 1.5 |
| `CircleArrowButton` | Projetos | círculo 40 com borda e `arrow_up_right` |
| `TagChip` | Stack | pill 30, borda `navy` 28% |
| `FilterPill` | Projetos | pill 36, selecionado = fundo `navy` texto `sand` |
| `BadgePill` | Projetos, Stack | pill mostarda ("Destaque", "Especialista") |
| `StatusPill` | Início | ponto + texto ("Disponível agora") |
| `AppIcon` | todas | wrapper do `SvgPicture` com `AppIconType` enum |
| `LoadingView` / `ErrorView` | todas | estados de carregamento e erro dos Blocs |

---

## 6. Features

Todos os Blocs seguem o mesmo contrato:
- Evento inicial `<Feature>Started` disparado no `BlocProvider(create: ... ..add(Started()))`.
- Estados `sealed`: `<Feature>Initial`, `<Feature>Loading`, `<Feature>Loaded(dados)`, `<Feature>Failure(AppFailure)`.
- `Equatable` em eventos, estados e models.

### 6.1 Início (`/`)
- **JSON** `profile.json`: `firstName`, `lastName`, `greeting`, `role`, `bio`, `available` (bool), `availabilityLabel`, `photo`, `stats[] { title, subtitle, emphasis }`.
- **Bloc** `HomeBloc`: `HomeStarted`.
- **View**: `PageHeader(trailing: StatusPill)` → `HomeGreeting` → `HomeNameTitle` (sobrenome em `terracotta`) → bio → linha com `ProfilePhotoCard` (arco + círculo mostarda) e `HighlightStatsList` → `HomeActions` ("Ver projetos" vai para a aba Projetos, "Contato" vai para a aba Contato, via `StatefulNavigationShell.goBranch`).

### 6.2 Projetos (`/projetos`)
- **JSON** `projects.json`: `id`, `name`, `client`, `summary`, `roles[]` (papéis do Luan: Idealizador, PO, Desenvolvimento, QA, Deploy), `tags[]`, `categories[]` (`maps | payments | management | games`), `featured` (bool), `rating`, `ratingCount`, `thumbColor` (nome do token: `navy | mustard | terracotta`, convertido para `AppColors` no model), `icon`, `screenshot`, `url` (loja).
- **Model** `ProjectCategory` enum: `all, maps, payments, management, games`. Labels em `AppStrings`: Todos, Mapas, Pagamentos, Gestão, Jogos. O filtro "Mobile" do design saiu porque todos os projetos são mobile.
- Linha secundária (decidido pelo Luan na Fase 5, porque o design só tem uma linha por card): **`FeaturedProjectCard` mostra `roles`** ("PO · Desenvolvimento · QA · Deploy") e **`ProjectListTile` mostra `tags`** ("Google Maps · Tempo real · Chat"), ambos unidos por " · ". As `tags` também continuam como `TagChip` na Stack.
- Prints de loja entram em `assets/` só com a tela do app: sem barra de status, sem moldura de aparelho e sem título de marketing (o `PhoneMockup` já desenha a moldura).
- Imagem ausente (`icon`/`screenshot` inexistente no bundle) cai no fallback do design: bloco com `thumbColor` e texto placeholder, sem quebrar a tela.
- Projetos (`assets/data/projects.json`, dados da App Store): Stive Maps, Rodovias Transportes, FlyPhotos, Brasília Basquete, ExpertGov, PabLife, **Casedoku (destaque)**.
- O `FeaturedProjectCard` usa 236 como **altura mínima**, não fixa: os resumos reais são bem mais longos que o texto do design e, com altura fixa, a última linha era cortada. A moldura do celular continua ancorada no topo e é recortada pela borda do card, como no design.
- **Bloc** `ProjectsBloc`: `ProjectsStarted`, `ProjectsFilterChanged(category)`, `ProjectOpened(project)`.
  `ProjectsLoaded` guarda `projects`, `selectedCategory` e expõe getters `featured` e `others` já filtrados.
- **View**: `PageTitle` → `ProjectFilterBar` (scroll horizontal) → `FeaturedProjectCard` (fundo `terracotta`, `BadgePill`, `PhoneMockup` rotacionado -7°) → `DividedColumn` de `ProjectListTile` (thumbnail 56, nome, tags unidas por " · ", `CircleArrowButton`).
- Toque no item abre `url` via `LinkLauncher`.

### 6.3 Stack (`/stack`)
- **JSON** `stack.json`: `highlight { title, subtitle, level }`, `groups[] { label, items[] }`.
- **Bloc** `StackBloc`: `StackStarted`.
- **View**: `PageTitle` → `StackHighlightCard` (fundo `navy`, `BadgePill` "Especialista") → `DividedColumn` de `SkillGroupRow` (label 84px + `Wrap` de `TagChip`).

### 6.4 Trajetória (`/trajetoria`) — tela escura
- **JSON** `trajectory.json`: `experiences[] { period, role, company, mode, description, current }`, `education[] { course, detail }` (unidos por " · " na tela).
- No site, a linha horizontal termina com uma **seta** (`arrow_right` em `mustard 35%`, mesma espessura de traço da linha), sinalizando que a trajetória continua. O `Positioned` dela é calculado a partir do centro da linha, não do topo, senão a seta desce 10px.
- **Ordem cronológica: do início da carreira para o atual** (2014 → hoje), decidido pelo Luan em 23/09. A ordem do JSON é a ordem da tela, nas duas interfaces: no app a timeline desce e o dot preenchido (`current`) fica no último item; no site ela corre da esquerda para a direita e o atual fica à direita. Travado em `local_trajectory_repository_test.dart`.
- **Bloc** `TrajectoryBloc`: `TrajectoryStarted`.
- **View**: `PageTitle` → `TimelineList` de `TimelineItem` (`TimelineDot` preenchido `terracotta` com halo se `current`, senão anel mostarda; linha vertical mostarda 35% exceto no último) → `EducationCard` (fundo `navyDeep`).

### 6.5 Contato (`/contato`) — tela terracota
- **JSON** `contact.json`: `title`, `subtitle`, `links[] { type (email | whatsapp | linkedin | github), label, value, url }`, `resumeUrl`.
- **Bloc** `ContactBloc`: `ContactStarted`, `ContactLinkPressed(url)`, `ResumeDownloadPressed`.
  Falha ao abrir link emite `ContactLoaded` com `launchFailure` preenchido; a Page mostra SnackBar via `BlocListener`.
- **View**: `ContactHero` → `DividedColumn` de `ContactLinkTile` (borda `white` 32%) → `ResumeButton` (`PrimaryPillButton` fundo `sand`, ícone `download`).

---

## 6.6 Site (Web)

O design `assets/Site · desktop-html.zip` (1440×4400) substitui a interface de app na Web.

- **Uma página só**, rolável: header → hero → stats → Projetos → Stack → Trajetória → Contato → rodapé.
- As **5 rotas continuam existindo**: `/projetos`, `/stack`, `/trajetoria` e `/contato` abrem a mesma página e rolam até a seção (`Scrollable.ensureVisible`); os links do header navegam com `context.go`, então a URL acompanha e o voltar do navegador funciona.
- **Um `MultiBlocProvider` no builder da rota** cria os 5 Blocs de uma vez, porque todas as seções aparecem juntas. Cada seção tem seu próprio estado de carregamento/erro, então uma falha isolada não derruba a página inteira.
- **Responsivo por breakpoint**, não por plataforma: conteúdo centralizado com largura máxima 1440 e gutter 80 (24 no compacto). Abaixo de `SiteMetrics.compactBreakpoint` (900) as colunas viram pilha, a timeline vira vertical, o card de destaque esconde os mockups e os títulos caem para a escala de seção. Abaixo de `statusBreakpoint` (1200) o header esconde o pill "Disponível agora" e a nav pode rolar na horizontal — sem isso o header estourava entre 900 e 1440.
- Verificado sem overflow de 360 a 1600px de largura. Em 1440 a página fecha com 4229px de altura (o design tem 4400).
- O CTA do card de destaque abre a loja (`AppStrings.siteFeaturedCta`, "Ver na loja"), não um estudo de caso — o design previa uma página que não existe.
- **Os links do header rolam, não navegam** (decisão do Luan): é uma página só, então trocar de rota a cada clique não fazia sentido. As rotas continuam existindo só para link direto — abrir `/stack` carrega a página já rolada na seção. A URL não muda ao clicar no menu.
- **O card de destaque mostra um celular só, com o print do próprio projeto.** O design tinha dois, e o segundo acabava exibindo o print do projeto seguinte (o destaque é Casedoku e aparecia Stive Maps). Abaixo de `SiteMetrics.featuredPhoneMin` (940 de largura de card) o celular some, senão ele invade a coluna de texto.

---

## 7. Navegação e shell

- `GoRouter` com `StatefulShellRoute.indexedStack` e 5 branches na ordem: Início, Projetos, Stack, Trajetória, Contato.
- `AppShellPage` recebe o `StatefulNavigationShell`, resolve a `ScreenPalette` pelo índice, anima o fundo, aplica `AnnotatedRegion<SystemUiOverlayStyle>` e posiciona a `BottomNavBar` flutuando sobre o conteúdo (conteúdo com padding inferior = altura da nav + margens + safe area).
- Conteúdo de cada página é rolável (`CustomScrollView`), porque o design é 390×844 fixo e telas menores precisam rolar.
- Web: `usePathUrlStrategy()` para URLs sem `#`.

---

## 8. Pacotes

Adicionar sempre com `flutter pub add` para pegar a versão estável mais recente.

- dependências: `flutter_bloc`, `equatable`, `go_router`, `url_launcher`, `flutter_svg`
- dev: `bloc_test`, `mocktail`, `flutter_lints`, `integration_test` (SDK, só para as capturas de loja da Fase 10)

`analysis_options.yaml` (além de `flutter_lints`): `always_use_package_imports`, `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_single_quotes`, `require_trailing_commas`, `sort_constructors_first`, `avoid_print`, `prefer_final_locals`, `use_super_parameters`.

---

## 9. Testes

- `test/` espelha `lib/`.
- **Blocs**: `bloc_test` + repositório mockado com `mocktail` (sucesso, falha, troca de filtro).
- **Repositórios locais**: `JsonAssetLoader` mockado retornando JSON de exemplo.
- **Models**: `fromJson` com JSON válido e campos faltando.
- **Widgets compartilhados**: widget tests (estado ativo da nav, filtro selecionado, dot atual da timeline).
- **Pages**: um smoke test por página com Bloc mockado.
- Testes também não têm comentários.

---

## 10. Roteiro de execução

Regras do roteiro:
- Uma fase por vez, na ordem. Ao terminar uma fase, parar e pedir para o Luan rodar e aprovar antes de seguir.
- Toda fase termina com: `flutter analyze` sem avisos, `flutter test` verde e checagem de comentários vazia:
  `grep -rnE '//|/\*' lib test '--include=*.dart' | grep -vE "https?://"` (as aspas em `--include` são obrigatórias no zsh)
- Marcar os itens `[x]` aqui conforme forem concluídos e atualizar a seção 0 (Status atual).
- Referência visual de cada tela: `docs/design/0X_<tela>.html` (abrir no navegador, 390×844).

### Fase 0 — Setup do projeto
- [x] Luan roda no Mac, dentro da pasta: `flutter create --org com.lumily --project-name portfolio_luan --platforms=ios,android,web .`
- [x] Fixar Bundle ID `com.lumily.portfolioluan`: `android/app/build.gradle(.kts)` (`applicationId`, `namespace`, pacote do `MainActivity`) e `PRODUCT_BUNDLE_IDENTIFIER` no `ios/Runner.xcodeproj` (Debug, Release, Profile)
- [x] Nome exibido do app: "Luan Nunes" (`AndroidManifest.xml` `android:label`, `Info.plist` `CFBundleDisplayName`, `web/manifest.json`, `<title>` do `web/index.html`)
- [x] Remover o contador padrão de `lib/main.dart` e `test/widget_test.dart`
- [x] `flutter pub add flutter_bloc equatable go_router url_launcher flutter_svg`
- [x] `flutter pub add --dev bloc_test mocktail` (manter `flutter_lints`)
- [x] `analysis_options.yaml` com as regras da seção 8
- [x] Fontes em `assets/fonts/`: Bricolage Grotesque (600, 700, 800) e Geist (400, 500, 600) em `.ttf`, declaradas no `pubspec.yaml`
- [x] 8 SVGs em `assets/icons/` com `stroke="currentColor"` (paths na seção 4)
- [x] `pubspec.yaml` declarando `assets/data/`, `assets/docs/`, `assets/icons/`, `assets/images/`, `assets/images/projects/`
- [x] Copiar `assets/docs/curriculo_luan_nunes.pdf` para `web/`
- [x] Criar a árvore de pastas da seção 3 (vazias por enquanto, cada uma com `.gitkeep` para o git versionar)
- [x] Validar: `flutter pub get`, `flutter analyze`, `flutter test`, `flutter build web`, `flutter build apk --debug`, `flutter build ios --simulator --no-codesign`

Origem das fontes (não existem estáticas no `google/fonts`, só variáveis): `github.com/ateliertriay/bricolage` → `fonts/ttf/` e `github.com/vercel/geist-font` → `fonts/Geist/ttf/`.

### Fase 1 — Core
- [x] `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius` com os valores da seção 4
- [x] `ScreenPalette` (light, dark, accent) com fundo, texto, texto secundário, logo, nav, divisor e `SystemUiOverlayStyle`
- [x] `AppTheme` (ThemeData com fontes, cores e `scaffoldBackgroundColor` transparente)
- [x] `AppStrings` (todos os textos fixos de UI), `AppAssets` (caminhos), `AppDurations`
- [x] `JsonAssetLoader` (recebe `AssetBundle`, retorna `Map<String, dynamic>`)
- [x] `LinkLauncher` (abre URL externa, retorna `bool` de sucesso)
- [x] `AppFailure` (tipos: carregamento, parse, link)
- [x] `context_extensions.dart` (acesso rápido a tema e tamanho de tela)
- [x] Testes: `JsonAssetLoader` e `LinkLauncher` com mocks
- [x] `app/app.dart` com o tema aplicado; `main.dart` só chama `runApp(const App())`. O `home` é um placeholder temporário, substituído pelo `GoRouter` na Fase 3.

Decisões tomadas na Fase 1:
- `letterSpacing` em Flutter é em pixels, não em `em`: os valores da seção 4 já entram convertidos (ex.: `heroName` -0.035em × 60 = -2.1).
- `LinkLauncher` recebe um `UrlOpener` (interface) em vez de chamar `launchUrl` direto — é o que torna o teste com `mocktail` possível. `ExternalUrlOpener` é a implementação real e mora no mesmo arquivo.
- `JsonAssetLoader` lança `AppFailure.load` (bundle falhou) ou `AppFailure.parse` (JSON inválido ou que não é objeto); os repositórios das próximas fases tratam.
- Campos de `ScreenPalette` não podem ser usados em expressão `const` (são campos de instância). Widgets recebem a paleta em runtime.
- **Toda tela precisa de um `Material` acima dos textos** (o `Scaffold` do shell resolve). Sem ele, o Flutter desenha todo `Text` em vermelho com sublinhado amarelo duplo — é o estilo de erro do `WidgetsApp`, não um problema de fonte ou de tema. Como `scaffoldBackgroundColor` é transparente, o fundo da tela vem do shell (Fase 3), não do `Scaffold`. Coberto pelo teste `test/app/app_test.dart`, que checa a cor com que o texto é de fato renderizado.

### Fase 2 — Widgets compartilhados
- [x] `LogoBadge`, `PageHeader`, `PageTitle`, `ResponsiveFrame`, `DividedColumn`
- [x] `AppIcon` + `AppIconType`
- [x] `PrimaryPillButton`, `OutlinePillButton`, `CircleArrowButton`
- [x] `TagChip`, `FilterPill`, `BadgePill`, `StatusPill`
- [x] `BottomNavBar`, `BottomNavItem`, `NavDestination`
- [x] `LoadingView`, `ErrorView`
- [x] Widget tests: estado ativo da nav, `FilterPill` selecionado/não selecionado, `DividedColumn` sem borda no primeiro item
- [x] `core/theme/app_sizes.dart` (novo): alturas, larguras e espessuras fixas do design. Sem ele os widgets ficariam cheios de números soltos, contra a regra 6.

Decisões tomadas na Fase 2:
- Widgets que existem em telas de paletas diferentes (`LogoBadge`, `PageHeader`, `PageTitle`, `BottomNavBar`, `LoadingView`, `ErrorView`) recebem a `ScreenPalette` inteira; os átomos (`TagChip`, `FilterPill`, `BadgePill`, botões) recebem cores soltas, porque nem sempre a cor vem da paleta da tela.
- As cores da `BottomNavItem` (mostarda/`mutedGray`/`sand`) são fixas nas 5 telas — só o fundo da barra muda por paleta, então só ele vem da `ScreenPalette`.
- `app/app.dart` tem, temporariamente, uma vitrine dos widgets compartilhados no lugar do placeholder, para dar o que aprovar na Fase 2. A Fase 3 substitui tudo isso pelo `GoRouter` + `AppShellPage`, incluindo os dois `_PreviewRow`/`_ignore*` do fim do arquivo.

### Fase 3 — Shell e navegação
- [x] `AppRoutes` (5 paths: `/`, `/projetos`, `/stack`, `/trajetoria`, `/contato`) + nomes e índices das abas
- [x] `AppRouter` com `StatefulShellRoute.indexedStack`
- [x] `AppShellPage`: fundo animado pela `ScreenPalette`, `AnnotatedRegion` da status bar, `BottomNavBar` flutuante, padding inferior do conteúdo
- [x] `App` com `MaterialApp.router`
- [x] `main.dart` com `usePathUrlStrategy()`
- [x] 5 páginas placeholder só com `PageHeader` + título
- [x] Validar: navegação entre abas, troca de cor de fundo e URL (widget test em `test/app/shell/views/app_shell_page_test.dart`)

Decisões tomadas na Fase 3:
- **`MultiRepositoryProvider` ficou para a Fase 4.** `Nested` (base do provider) tem `assert(children.isNotEmpty)`, então um `MultiRepositoryProvider(providers: [])` quebraria em runtime. Ele entra junto com o `ProfileRepository`.
- `App` virou `StatefulWidget` só para guardar o `GoRouter` em `late final`: recriar o router a cada `build` perderia o estado de navegação.
- Quem decide a paleta é `ScreenPalette.byTab` (lista de 5, indexada pela aba). O shell usa `forIndex(currentIndex)` e cada página usa `forIndex(AppRoutes.<x>Index)` — uma fonte só, sem risco de shell e página discordarem.
- Espaço reservado para a nav = `navBar 68 + navBottomMargin 20 + safe area`, aplicado como padding inferior no `navigationShell`. O `SafeArea` do shell é `bottom: false`, senão a folga seria contada duas vezes.
- `flutter_web_plugins` entrou no `pubspec` por causa do `usePathUrlStrategy()`. O import é seguro no mobile: o `url_strategy.dart` do SDK tem export condicional com stub para não-web.
- `usePathUrlStrategy()` tira o `#` da URL, mas exige que o servidor devolva `index.html` em qualquer rota. Configurar isso no deploy da Fase 10 (rewrite `/** -> /index.html`), senão abrir `/projetos` direto dá 404.

### Fase 4 — Início
- [x] `assets/data/profile.json` (dados do currículo: nome, cargo, bio, disponibilidade, 3 stats)
- [x] `ProfileModel`, `HighlightStatModel` com `fromJson`
- [x] `ProfileRepository` + `LocalProfileRepository`
- [x] `HomeBloc`, `HomeEvent`, `HomeState`
- [x] `HomePage` + widgets da seção 6.1 (foto real em `ProfilePhotoCard`)
- [x] Botões "Ver projetos" e "Contato" trocando de aba
- [x] Testes: model, repositório, bloc, smoke test da página
- [x] `MultiRepositoryProvider` no `App` (adiado da Fase 3)

Decisões tomadas na Fase 4 (valem para as Fases 5–8):
- **Padrão de página:** a `Page` pública faz o `BlocBuilder` e o `switch` dos estados (`Loading` → `LoadingView`, `Failure` → `ErrorView` com retry, `Loaded` → conteúdo); o layout do estado carregado fica num `_XContent` privado no mesmo arquivo. Evita `_buildX()` (regra 4) sem criar um widget público que só a página usa.
- **`App` recebe `AssetBundle?`** (`bundle`), usado só por testes. Sem essa costura, todo teste que monta o `App` dependeria de I/O real de asset, que não completa de forma determinística dentro do ambiente `testWidgets` — os testes do shell falhavam de forma intermitente por isso. Produção continua usando `rootBundle`.
- **`pumpAndSettle` não funciona com o `LoadingView`:** o `CircularProgressIndicator` anima para sempre e o settle nunca termina. Os testes de App/shell usam `pump()` + `pump(AppDurations.paletteTransition)`.
- Testes que tocam na Início fixam a janela em 390×844 (`tester.view.physicalSize`), senão o conteúdo abaixo da dobra não é construído e os botões não são encontrados.
- `test/features/home/repositories/profile_asset_test.dart` carrega o `profile.json` **real** pelo `rootBundle` e valida o conteúdo — é o teste que pega erro de digitação no JSON, já que os demais usam `FakeAssetBundle`.
- `role` e `bio` repetem a frase "Desenvolvedor Flutter Pleno/Sênior" de propósito: `bio` é o parágrafo exatamente como o design mostra, e `role` é o dado estruturado, usado hoje no rótulo de acessibilidade do nome.
- O divisor dos stats usa `navyAlpha20` (o design usa 20% aqui, não os 18% padrão da paleta).

### Fase 5 — Projetos
- [x] Revisar `assets/data/projects.json` (já existe) contra o model — os 7 projetos já estavam completos, nada mudou no JSON
- [x] `ProjectModel`, `ProjectCategory`
- [x] `ProjectsRepository` + `LocalProjectsRepository`
- [x] `ProjectsBloc` com `ProjectsStarted`, `ProjectsFilterChanged`, `ProjectOpened`
- [x] `ProjectsPage` + widgets da seção 6.2 (`PhoneMockup` com print real, `ProjectThumbnail` com ícone real e fallback de cor)
- [x] Toque abre o link da loja
- [x] Testes: filtro por categoria, destaque separado da lista, fallback de imagem

Decisões tomadas na Fase 5:
- **Linha secundária:** destaque = `roles`, item da lista = `tags` (ver seção 6.2). O design só comporta uma linha por card.
- `ProjectOpened` que falha emite `ProjectsLoaded` com `launchFailure` e a Page mostra SnackBar — mesmo contrato da tela de Contato (seção 6.5), para as duas telas com link externo se comportarem igual.
- `ProjectsLoaded.featured` é o primeiro projeto com `featured: true` **dentro do filtro atual**. Filtrando por Jogos, nenhum é destaque, então o card some e todos viram lista — é o comportamento coberto por teste.
- `LinkLauncher` virou `RepositoryProvider` no `App`, para o `ProjectsBloc` (e depois o `ContactBloc`) receberem por injeção e os testes mockarem.
- **Fallback de imagem:** o `PhoneMockup` mostra `AppStrings.projectImageFallback` sobre fundo `sand`; o `ProjectThumbnail` (56px) só mostra o bloco de `thumbColor`, sem texto, que não caberia nesse tamanho.
- Filtro só muda `selectedCategory` no estado; não recarrega o repositório (coberto por teste com `verify(...).called(1)`).

### Fase 6 — Stack
- [x] `assets/data/stack.json` (grupos do design + enriquecimentos do currículo)
- [x] `StackModel`, `SkillGroupModel`, `StackHighlightModel`
- [x] `StackRepository` + `LocalStackRepository`
- [x] `StackBloc`
- [x] `StackPage` + `StackHighlightCard`, `SkillGroupRow`
- [x] Testes: model, repositório (incl. JSON real), bloc, smoke test

Decisões tomadas na Fase 6:
- `stack_highlight_model.dart` é um arquivo a mais do que a seção 3 listava. O `highlight` tem 3 campos próprios; achatá-los dentro do `StackModel` misturaria dois assuntos no mesmo model.
- `highlight` é opcional (`StackHighlightModel?`): sem ele a tela mostra só os grupos, sem quebrar. Coberto por teste.
- São 9 grupos: os 6 do design (Estado, Backend, Pagamentos, Mapas, Qualidade, CI/CD) + os 3 do currículo (Monitoramento, Nativo, Métodos). "Nativo" virou `Kotlin`, `Swift` e `Flutter Channels` como três chips, em vez do "Swift (Flutter Channels)" entre parênteses — fica coerente com o resto, que é uma tecnologia por chip.
- O divisor entre grupos usa `navyAlpha16` (o design usa 16% aqui, não os 18% padrão da paleta).

Bug corrigido depois da revisão do Luan (valia para `TagChip`, `BadgePill` e `FilterPill`):
- **`Container` com `alignment` estica até a largura máxima disponível.** Era o que fazia cada `TagChip` ocupar uma linha inteira na Stack e o "Destaque" esticar no card de Projetos. A correção é `child: Center(widthFactor: 1, child: ...)` no lugar de `alignment: Alignment.center` — aí o chip abraça o texto. Travado por `test/shared/widgets/chips/chips_hug_content_test.dart`.
- **Rótulo dos grupos não quebra linha:** a coluna de rótulos não é mais fixa em 84px. A `StackPage` mede com `TextPainter` (respeitando o `textScaler` do sistema) o rótulo mais largo e passa essa largura para todos os `SkillGroupRow`, então "Monitoramento" cabe numa linha e os chips continuam alinhados entre os grupos. `AppSizes.skillGroupLabel` virou o piso dessa conta.
- **Largura de texto em widget test não vale como medida visual:** a fonte de teste do Flutter dá a mesma largura a todo glifo (~1em), então um chip de 8 caracteres mede ~132px no teste e bem menos com a Geist real. Ao conferir layout em teste, comparar chip × texto (proporção), nunca o valor absoluto.

### Fase 7 — Trajetória
- [x] `assets/data/trajectory.json` (3 experiências + formação)
- [x] `ExperienceModel`, `EducationModel`, `TrajectoryModel`
- [x] `TrajectoryRepository` + `LocalTrajectoryRepository`
- [x] `TrajectoryBloc`
- [x] `TrajectoryPage` + `TimelineList`, `TimelineItem`, `TimelineDot`, `EducationCard`
- [x] Validar paleta escura (logo invertido, nav `navyDeep`, status bar clara)
- [x] Testes: dot atual vs. anterior, linha ausente no último item

Decisões tomadas na Fase 7:
- **`education[]` virou lista de objetos `{ course, detail }`**, não de strings como a seção 6.4 dizia. O design mostra "Flutter & Dart · Especialização online": com o separador dentro da string, o " · " viraria texto solto no JSON. Assim o `EducationCard` junta com `AppStrings.separator`, igual às outras telas, e o `education_model.dart` previsto na seção 3 passa a ter motivo de existir.
- **A linha vertical da timeline usa `IntrinsicHeight`**: no design ela é `position: absolute` de um item até o próximo, o que no Flutter vira uma coluna (dot + `Expanded` da linha) que precisa saber a altura do texto ao lado. O último item não recebe a linha.
- A formação do currículo tem 3 entradas; o `trajectory.json` traz as 2 que o design mostra (Flutter & Dart e Fibra óptica/NR-35/NR-10/SENAI). "Eletrônica Básica · Ensino Médio" ficou de fora, como no design.

### Fase 8 — Contato
- [x] `assets/data/contact.json` (4 links + `resumeUrl` provisório)
- [x] `ContactModel`, `ContactLinkModel`, `ContactLinkType`
- [x] `ContactRepository` + `LocalContactRepository`
- [x] `ContactBloc` com `ContactStarted`, `ContactLinkPressed`, `ResumeDownloadPressed`
- [x] `ContactPage` + `ContactHero`, `ContactLinkTile`, `ResumeButton`, SnackBar de erro via `BlocListener`
- [x] Validar paleta terracota
- [x] Testes: falha ao abrir link emite erro, sucesso não emite

Decisões tomadas na Fase 8:
- **`resumeUrl` provisório:** `https://www.lumily.com.br/curriculo_luan_nunes.pdf` (domínio que o Luan já tem). O PDF ainda não está lá, então hoje o botão mostra a SnackBar de erro. Resolver no deploy da Fase 10 — já está no Backlog.
- **`ContactLinkType` é anulável no model:** um `type` desconhecido no JSON não derruba o link, que continua aparecendo com o `label` do JSON. Só o ícone/semântica dependeriam do tipo.
- O `label` do link vem do JSON quando existe e cai no label do enum quando não vem.
- **`PrimaryPillButton` ganhou `Flexible` + elipse no texto.** "Baixar currículo (PDF)" com o ícone estourava a largura em telas estreitas (e estourava também com fonte ampliada). Isso corrigiu um bug que já existia desde a Fase 2 e vale para os dois usos do botão.

### Fase 9 — Polimento
- [x] Animações de entrada suaves (fade + slide curto, escalonado) usando `AppDurations`
- [x] `ResponsiveFrame` na Web/tablet (máx. 480, centralizado, fundo preenchendo a tela)
- [x] Acessibilidade: `Semantics` nos botões e na nav, contraste, tamanho de toque mínimo 44
- [x] **Ícone do app (iOS, Android, Web favicon) e splash** — feito com a arte que o Luan entregou (`assets/Marca-selection.png` e `assets/Splash-html.zip`). **A splash é `navy`, não `sand`:** o design entregue pelo Luan usa fundo `#1E3441`, e ele manda mais que o texto original desta linha.
- [ ] Revisão visual lado a lado com `docs/design/` — é do Luan

Decisões tomadas na Fase 9:
- **`FadeSlideIn`** (`shared/widgets/layout/`) envolve cada bloco das 5 páginas: fade + 12px de slide, `AppDurations.entrance` (400ms) com `AppDurations.entranceStagger` (80ms) por ordem. Um `AnimationController` por bloco com `Interval` calculado — sem `Future.delayed`, que deixaria timers pendentes e quebraria os testes.
- **Alvo de toque de 44:** `CircleArrowButton` (círculo visual 40 dentro de caixa 44) e `FilterPill` (pill visual 36 dentro de área 44, via padding dentro do `InkWell`). Os dois mantêm o tamanho visual do design; só a área sensível cresceu.
- **Contraste:** todas as combinações da paleta passam no WCAG AA sem mudar nenhuma cor. A mais justa é `white` sobre `terracotta` (4.99). Travado em `test/core/theme/app_colors_contrast_test.dart`, que recalcula a razão de contraste — se alguém mexer numa cor, o teste avisa.
- `OutlinePillButton` também ganhou elipse e padding horizontal, pelo mesmo motivo do `PrimaryPillButton` na Fase 8.
- **O ponto da nav desliza entre as abas.** Antes ele sumia e reaparecia porque cada `BottomNavItem` desenhava o seu. Agora o ponto é único e mora na `BottomNavBar`, posicionado por `AnimatedPositioned` (`AppDurations.navIndicator`, 280ms, `easeOutCubic`) sobre a `Row` de abas. Para isso o item deixou de desenhar o ponto e reserva o espaço com `AppSizes.navDotTop` (10) — é esse token que mantém o ponto e o overlay alinhados, sem depender da altura do rótulo. O rótulo virou `maxLines: 1` com elipse, senão "Trajetória" quebra em duas linhas quando o slot é estreito ou a fonte do sistema está ampliada.
- **A bottom nav não tem ripple.** O `InkWell` do `BottomNavItem` pinta o retângulo inteiro da aba, e aparecia um quadrado cinza sobre a pill arredondada. Agora usa `NoSplash.splashFactory` com splash/highlight/hover transparentes: o feedback do toque é a troca de cor e o ponto mostarda, como no design. Coberto por teste.
- Semântica de botão vem do `Semantics(button: true)` **sem `label`**: o `Text` filho já fornece o rótulo, e passar os dois duplicava a leitura do VoiceOver ("Ver projetos, Ver projetos").

### Site Web (adendo ao roteiro, 23/09)
- [x] Interface de site para a Web a partir do design `Site · desktop`, detalhada na seção 6.6
- [x] Ajustes pedidos pelo Luan: menu rola em vez de navegar; destaque usa o print do próprio projeto; trajetória do início para o atual, com seta no fim da linha; "Caixa-preta" virou "Testes de comportamento" e o grupo Qualidade passou a usar nomes por extenso

### Fase 10 — Entrega

Preparação já feita (23/09):
- [x] **iOS pronto.** `flutter build ipa` gera `build/ios/ipa/portfolio_luan.ipa` (22 MB) já assinado para a App Store — o `DEVELOPMENT_TEAM` (RND8DJ6WQ6) e os certificados já estão configurados na máquina. Subir pelo Transporter ou `xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey <key> --apiIssuer <issuer>`.
- [x] **`Info.plist` com `ITSAppUsesNonExemptEncryption = false`** — evita a pergunta sobre criptografia a cada envio para o App Store Connect.
- [x] **Deployment target iOS 15.0** (24/09). O `flutter create` deixa 13.0, e o App Store Connect avisa no upload que a partir da primavera de 2027 só aceita 15.0 ou mais. **Subir não custa nenhum aparelho:** iOS 13, 14 e 15 rodam na mesma lista de aparelhos (iPhone 6s em diante) — quem foi cortado foi só o iOS 16.
  - São **dois lugares**, e os dois precisam mudar juntos: `IPHONEOS_DEPLOYMENT_TARGET` nas três configurações do `ios/Runner.xcodeproj/project.pbxproj` (Debug, Release, Profile) e `platform :ios, '15.0'` no `ios/Podfile` (a linha vem comentada por padrão). Só o pbxproj deixaria os pods em 13.0.
  - Depois de mexer, apagar `ios/Podfile.lock` e `ios/Pods/` antes do build, senão o CocoaPods reaproveita os pods antigos.
  - **Conferir no IPA, não no log:** `unzip` o `.ipa` e ler `MinimumOSVersion` em `Payload/Runner.app/Info.plist` (deve dar 15.0) e `vtool -show-build-version Payload/Runner.app/Runner` (`minos 15.0`). É o que o App Store Connect olha. Os frameworks embutidos (`Flutter.framework`, `url_launcher_ios.framework`) continuam marcados 13.0 e isso é normal — framework com mínimo menor roda sem problema num app de mínimo maior.
- **Os plugins de dev viajam no IPA de release.** `integration_test` e `flutter_native_splash` estão marcados `dev_dependency: true` no `.flutter-plugins-dependencies`, mas o `podhelper.rb` desta versão do Flutter não filtra isso no iOS: os dois frameworks são embutidos em `Payload/Runner.app/Frameworks/`. São 212 KB num IPA de 22 MB e a Apple aceitou o envio assim. Se algum dia incomodar, a saída é restringir esses pods à configuração `Debug` no `Podfile`.
- [x] **`<queries>` do `url_launcher` no `AndroidManifest`** (https, http, mailto, tel). Sem isso o Android 11+ esconde os apps que abrem links e **todos os toques em links falhariam em release** — o app debug não mostra o problema.
- [x] **Assinatura release do Android plugada** em `android/app/build.gradle.kts`: lê `android/key.properties` quando existe. Sem o arquivo, o build cai na chave de debug **e imprime um aviso em letras garrafais** — a Play Store recusa AAB assinado com chave de debug.
- [x] `android/key.properties` e `*.jks`/`*.keystore` no `.gitignore`; modelo em `android/key.properties.example`.

**Ordem recomendada: site primeiro, apps depois** — os apps dependem do site estar no ar para o botão do currículo funcionar.

- [x] **Keystore criada em 23/09** e `android/key.properties` preenchido. O AAB foi verificado com `jarsigner`: assinado por `CN=Luan Nunes Caldeira, OU=Lumily`, não mais pela chave de debug.
  - A keystore mora em **`android/app/luan_portifolio.jks`** (dentro do projeto, coberta por `**/*.jks` no `.gitignore`). **A única outra cópia está na Lixeira do macOS** — fazer backup em local seguro antes de esvaziar.
  - `storeFile` no `key.properties` é **relativo a `android/app/`** (convenção padrão do Flutter, via `file(...)` no módulo do app). Caminho absoluto também funciona.

Histórico do comando, caso precise gerar outra (uma vez na vida do app):
- [x] **Gerar a keystore de upload**:
  ```
  keytool -genkey -v -keystore ~/upload-keystore.jks -storetype JKS \
    -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  ```
  Copiar `android/key.properties.example` para `android/key.properties`, preencher as senhas e apontar `storeFile` para o caminho do `.jks`.
  **Guardar a keystore e as senhas em lugar seguro: perdê-las significa nunca mais conseguir atualizar o app na Play Store.**
- [x] `flutter build appbundle --release` + `jarsigner -verify -certs` — feito em 23/09, `build/app/outputs/bundle/release/app-release.aab` (43,7 MB) assinado corretamente.
- [x] Ficha das lojas: descrição, screenshots e política de privacidade (a Play exige URL de política mesmo para app sem coleta de dados — está em https://luan.lumily.com.br/privacidade).
- [x] `resumeUrl` resolvido: o PDF está no ar em https://luan.lumily.com.br/curriculo_luan_nunes.pdf e o botão "Baixar currículo" funciona nas três plataformas.
- [x] **Deploy Web feito em 23/09.** Projeto `luan-portfolio` na conta pessoal da Vercel (`codnamelouis1546-3519`), domínio `luan.lumily.com.br` anexado e verificado.
  - **Como redeployar:** `flutter build web --release` e `vercel deploy --prod` **na raiz do projeto** (não dentro de `build/web`). O `vercel.json` da raiz define `outputDirectory: build/web` e o rewrite `/(.*) → /index.html`; o `.vercel/` fica na raiz e sobrevive aos rebuilds.
  - **DNS na Hostinger:** registro `A` com nome `luan` → `76.76.21.21` (a Vercel pediu A, não CNAME, porque os nameservers são da Hostinger). Criado em 23/09, propagou em minutos.
  - **Armadilha do `.vercelignore`:** padrões sem barra inicial casam em qualquer nível — `web` e `assets` excluíam `build/web` e `build/web/assets`, e o deploy subia vazio com status "Ready" e 404 no navegador. Todos os padrões precisam de barra: `/web`, `/assets`, `/build/app`. E não usar `*` com exceções: o `*` continua valendo para os arquivos dentro das pastas reincluídas.
  - Peso da primeira visita: ~5,7 MB comprimido (12 MB cru).
  - **`/privacidade`** é uma página HTML estática (`web/privacidade.html`), exigida pelas duas lojas. Ela tem uma regra de rewrite **antes** da catch-all no `vercel.json`. Não usar `cleanUrls: true` para isso: testei e ele quebra o rewrite do app (`/projetos` passa a dar 404).
- [x] **Deployment Protection conferida:** o projeto usa "Vercel Authentication: Standard Protection", igual aos outros projetos da conta. É o ajuste correto — protege só as **prévias**; o domínio de produção fica público. Não mexer.
- [x] **Certificado TLS:** não saiu sozinho mesmo com DNS propagado e domínio verificado. Resolvido com `vercel certs issue luan.lumily.com.br` (15s). Lembrar disso ao adicionar outros subdomínios.
- [x] **Os três binários foram regerados em 23/09 à noite**, depois das últimas mudanças de conteúdo (ordem da trajetória, rótulos da Stack, print do Casedoku, seta da timeline). Válidos enquanto o conteúdo não mudar.
- [x] **App criado nas duas lojas** (o `bundle id` já existia: `com.lumily.portfolioluan`). Nome exibido: **Luan Nunes**.
  - **Apple:** o App ID foi criado automaticamente pelo Xcode no primeiro `flutter build ipa`. Por isso o App Store Connect respondia "App ID not available" ao tentar criar de novo — bastava cancelar e escolher o ID já existente na lista. Dá para confirmar isso lendo o `embedded.mobileprovision` dentro do IPA.
  - **Play:** ficha preenchida por IA no navegador, com o material da seção "Material de loja" abaixo.
- [x] **IPA enviado ao App Store Connect em 24/09** pelo Transporter (build 1.0.0+1), com um aviso de deployment target que já foi resolvido — ver a linha do iOS 15.0 acima.
- [ ] Enviar para revisão da Apple.
- [ ] Subir o AAB na Play Console e abrir o **teste fechado com 12 testadores por 14 dias** (exigência da Play para conta pessoal criada depois de nov/2023). É o caminho crítico do cronograma.

**Versão:** `pubspec.yaml` está em **1.0.0+2**. O `+1` já foi consumido pelo envio de 24/09 e o App Store Connect recusa build repetido — todo envio novo precisa de um número maior. O mesmo número vira o `versionCode` do Android.

#### Material de loja (gerado em 24/09)

| Item | Onde | Formato |
|---|---|---|
| Ícone da Play | `loja/icone-512.png` | 512×512 PNG, 15 KB |
| Gráfico de recursos | `loja/grafico-recursos-1024x500.png` | 1024×500 PNG, 62 KB |
| Capturas Android (celular) | `screenshots/android-phone/01…05.png` | 1328×2544, proporção 1,92 |
| Capturas iPhone 6.9" | `screenshots/iphone-6.9/01…05.png` | 1320×2868 |
| Capturas iPad 13" | `screenshots/ipad-13/01…05.png` | 2064×2752 — servem também para a aba "tablet" da Play |
| Política de privacidade | `web/privacidade.html` | no ar em https://luan.lumily.com.br/privacidade |

- **A Play recusa captura em que o lado maior passa do dobro do menor.** As do iPhone 6.9" têm proporção 2,17 e são rejeitadas lá (na Apple servem). Por isso existe o conjunto Android separado.
- **As capturas são geradas por automação, não à mão** — `integration_test/screenshots_test.dart` + `test_driver/screenshots.dart`, rodados com
  `flutter drive --driver=test_driver/screenshots.dart --target=integration_test/screenshots_test.dart -d <device>`.
  O teste monta o `App`, espera as animações de entrada assentarem e toca em cada aba pelo texto do `BottomNavItem`, salvando um PNG por tela em `screenshots/`. Vale a pena manter: regerar as cinco capturas depois de uma mudança de conteúdo custa um comando.
  - **`pumpAndSettle` não serve aqui** (mesmo motivo da Fase 4: o `LoadingView` anima para sempre). O teste faz 20 `pump(AppDurations.entrance)` seguidos.
  - **No Android é obrigatório chamar `binding.convertFlutterSurfaceToImage()`** antes do primeiro `takeScreenshot`, senão a captura sai preta. No iOS não é necessário nem suportado, daí o `if (Platform.isAndroid)`.
  - **Tamanho da tela do emulador dita a proporção da captura.** O emulador padrão (1344×2992, proporção 2,23) gera imagem que a Play recusa. Forçar antes com `adb shell wm size 1344x2560` e devolver com `adb shell wm size reset` no fim.
  - **A captura do Android vem com uma moldura verde de ~5px** (artefato do `convertFlutterSurfaceToImage`). As imagens em `screenshots/android-phone/` já saíram com 8px cortados de cada lado; refazer esse corte se gerar de novo.
- O **gráfico de recursos** é montado por script com PIL, usando as fontes de `assets/fonts/` e a paleta da seção 4 — a marca vem de `assets/branding/mark.png`, a mesma do ícone.

---

### Repositório público — o que o `.gitignore` segura (24/09)

O repositório é público, então a regra é: **nada de credencial na árvore versionada.** O `.gitignore` da raiz mais os de `android/` e `ios/` cobrem, cada um com a regra que pega:

| O que | Regra |
|---|---|
| `android/key.properties` (senhas em texto puro) | `**/key.properties` na raiz + `key.properties` no `android/` |
| `android/app/luan_portifolio.jks` | `**/*.jks`, `**/*.keystore` |
| Assinatura e API da Apple | `**/*.p12`, `**/*.p8`, `**/*.cer`, `**/*.certSigningRequest`, `**/*.mobileprovision` |
| Credenciais de serviço (preventivo, nenhum em uso) | `**/google-services.json`, `**/GoogleService-Info.plist` |
| Vercel e variáveis de ambiente | `.vercel`, `.env*` |
| Binários de release fora de `/build/` | `*.aab`, `*.apk`, `*.ipa` |
| Caminhos locais da máquina | `android/local.properties`, `ios/Flutter/Generated.xcconfig`, `ios/Flutter/flutter_export_environment.sh` (já vinham do Flutter) |

- **`android/key.properties.example` continua versionado de propósito** — é o modelo, sem senhas. `**/key.properties` não casa com ele, porque o nome é outro.
- **Conferir antes do primeiro push**, não confiar na leitura do arquivo:
  ```
  git check-ignore -v android/key.properties android/app/*.jks .vercel
  git status --porcelain -uall | wc -l
  ```
  Em 24/09 isso dava 413 arquivos, 11,6 MB — sem `build/`, sem `Pods/`, sem `.dart_tool/`. As capturas de loja (~8 MB) são a maior parte e vão junto de propósito.
- **Cuidado ao procurar vazamento com `grep -F "$SENHA"`:** a senha é a palavra `upload`, então ela casa como substring em "keystore de upload" e em `upload-keystore.jks` no modelo. Os dois primeiros alarmes foram falsos por isso. Comparar valor inteiro, não substring.

---

## 11. Conteúdo

### Já fornecido
- [x] Foto de perfil: `assets/images/profile.jpg` (redimensionada para 720×1083, recorte `BoxFit.cover` alinhado ao topo no `ProfilePhotoCard`)
- [x] Currículo PDF: `assets/docs/curriculo_luan_nunes.pdf` é a fonte. Na Fase 0 ele é copiado para `web/curriculo_luan_nunes.pdf`, para ser servido pelo deploy Web. `contact.json → resumeUrl` aponta para a URL pública (`https://<dominio>/curriculo_luan_nunes.pdf`), então o mesmo link funciona no mobile via `LinkLauncher`
- [x] E-mail de contato confirmado: `luan@afcinfotelecom.net`
- [x] Bundle ID: `com.lumily.portfolioluan`. Criar com `flutter create --org com.lumily --project-name portfolio_luan` e depois fixar o ID em `android/app/build.gradle(.kts)` (`applicationId` e `namespace`) e em `PRODUCT_BUNDLE_IDENTIFIER` no Xcode (Runner, todas as configurações)
- [x] Textos de perfil, stack, trajetória e formação: currículo (sem divergências com o design)
- [x] Projetos: 7 apps da App Store, rascunho em `assets/data/projects.json`
- [x] Papéis do Luan em cada projeto (`roles`)
- [x] Ícones e prints dos 7 projetos em `assets/images/projects/<id>_icon.png` e `<id>_screen.png` (nome de paciente borrado no print do PabLife)

### Pendente
- Nada bloqueante. Itens restantes estão no Backlog (seção 13).

### Enriquecimentos vindos do currículo (aplicados no `stack.json` na Fase 6)
- [x] Grupo **Monitoramento**: Crashlytics, Analytics, Performance
- [x] Grupo **Nativo**: Kotlin, Swift, Flutter Channels
- [x] Grupo **Métodos**: Git, Scrum, Kanban, Code Review

## 12. Decisões em aberto

- Tela de detalhe do projeto (`/projetos/:id`) ou manter o toque abrindo link externo (padrão atual).
- Internacionalização PT/EN no futuro: todos os textos já ficam centralizados em `AppStrings` e nos JSONs para facilitar.

## 13. Backlog (para quando o app estiver rodando)

### Bloqueiam a publicação nas lojas
- [x] ~~Keystore do Android~~ — criada em 23/09, `key.properties` preenchido, AAB assinado e verificado.
- [ ] **Backup da keystore** `android/app/luan_portifolio.jks` + senha em lugar seguro. Hoje a única cópia extra está na Lixeira do macOS.
- [x] ~~Subir o site~~ — **no ar em https://luan.lumily.com.br desde 23/09**. O `resumeUrl` responde 200 com `application/pdf`, então o botão "Baixar currículo" funciona nos apps.
- [x] ~~URL de política de privacidade~~ — https://luan.lumily.com.br/privacidade, no ar desde 23/09.
- [x] ~~Ficha das lojas: descrição, screenshots e categoria~~ — material gerado em 24/09, tabela na Fase 10.
- [ ] **12 testadores no teste fechado da Play, por 14 dias seguidos** — exigência para conta pessoal criada depois de nov/2023. É o prazo mais longo entre o que falta.

### Resto
- [ ] Revisar os textos que o Claude escreveu por não estarem no design: `AppStrings.projectImageFallback` ("Imagem indisponível"), `failureLoad`, `failureParse`, `failureLink` e `retry`
- [x] ~~`git init` no projeto~~ — feito em 24/09, branch `main`, sem commit ainda. **O repositório vai ser público** (decisão do Luan): é peça de portfólio, e o conteúdo — textos, prints, currículo, contatos — já está público no site e nas lojas.
- [ ] **Trocar a senha da keystore.** Hoje `storePassword` e `keyPassword` são a palavra `upload`, seis caracteres. O `.jks` não vai para o repositório, então só protege contra vazamento do arquivo em si (backup, sync de nuvem, notebook perdido). Dá para trocar sem perder a assinatura do app, porque a chave não muda:
  ```
  keytool -storepasswd -keystore android/app/luan_portifolio.jks
  keytool -keypasswd -alias upload -keystore android/app/luan_portifolio.jks
  ```
  Depois atualizar `android/key.properties`.
- [ ] **Tirar a keystore de dentro do projeto.** `android/app/luan_portifolio.jks` está coberto pelo `.gitignore`, mas essa é a única barreira num repositório público. Movida para fora da árvore (`storeFile` aceita caminho absoluto), a proteção deixa de depender de uma regra de texto.
- [x] ~~Domínio do deploy Web~~: `luan.lumily.com.br` (decidido em 23/09), `resumeUrl` já atualizado
- [x] ~~Rewrite `/** -> /index.html`~~: `web/vercel.json` faz isso e é copiado para `build/web/` em todo build
- [ ] Revisão do Luan nos resumos, tags e no destaque dos projetos, vendo no app
- [x] ~~`casedoku_screen.png`~~ trocado em 23/09 pela captura em 590×1280 que o Luan enviou
- [ ] Trocar `expertgov_screen.png` (161px) por captura original em alta resolução
