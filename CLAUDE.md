# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Toolchain

Flutter SDK is pinned via FVM in `.fvmrc` (currently `3.38.9`). Prefix Flutter/Dart commands with `fvm` so they use the pinned version:

```bash
fvm flutter pub get
fvm flutter run                       # default device
fvm flutter test                      # full suite
fvm flutter test test/features/avatar_filters/ui/pages/avatar_filters_page_test.dart   # single file
fvm flutter test --name 'Avatar filters'           # by test name regex
fvm flutter analyze                   # static analysis (uses analysis_options.yaml + flutter_lints)
fvm dart format lib test
```

There is no separate lint step — `flutter analyze` is the lint command. Use `nano` for ad-hoc shell edits (per global instructions).

## Architecture (read before adding features)

The project deliberately follows a strict GetX + Clean Architecture pattern documented in `docs/`. Treat these as authoritative — they describe rules the existing code already obeys, and new features must match:

- `docs/ARCHITECTURE.md` — layer responsibilities, dependency direction (`UI → Presentation → Domain ← Data`), naming conventions, forbidden patterns.
- `docs/STATE_MANAGEMENT.md` — GetX reactive types, controller/binding patterns, route registration, worker usage, `GetConnect` client.
- `docs/FLUTTER_DART_BEST_PRACTICES.md` — widget/style rules (small widget classes over `_buildX` helpers, `const` everywhere, `final` by default, no business logic in widgets).
- `docs/DART_3_CORE_MODIFIERS.md` — required Dart 3 class-modifier policy: every class/mixin declaration must pick the most restrictive modifier that fits (`abstract final class` for static namespaces, `abstract interface class` for repository/data-source contracts, `final class` for entities/models/DTOs, `sealed class` for exhaustive state unions, `mixin` for shared behavior). A bare `class` is only acceptable when no stronger modifier fits.

### Per-feature layout

Every feature under `lib/features/<name>/` must have all four layers:

```
data/         datasources/, models/, repositories/   (DTOs, API/storage, RepositoryImpl)
domain/       entities/, repositories/, usecases/    (pure Dart, no Flutter/GetX imports)
presentation/ bindings/, controllers/                (GetX wiring + Rx state)
ui/           pages/, widgets/                       (StatelessWidget/StatefulWidget only)
```

The reference implementation is `lib/features/avatar_filters/` — mirror its file layout, naming, and DI wiring when adding a feature. Note specifically:

- Domain entities are pure Dart (`AvatarEntity`, `AvatarFiltersEntity`, enums under `domain/entities/`). `AvatarFiltersEntity` keeps an immutable `Map<AvatarFilterCategory, Set<Enum>>` so new filter categories can be added without changing the entity, while avoiding mutable collections and stringly typed values.
- Models live in `data/models/` and provide `toEntity()` mappers; entities never know about JSON.
- The repository interface is in `domain/repositories/`; the impl is in `data/repositories/`. The impl is the only place that talks to a `*Datastore`/data source.
- Use cases (`*UseCase` with a `call(...)` method, making them callable as functions) are the only way controllers reach domain logic. `ApplyAvatarFiltersUseCase` is an example of a pure-logic use case (no repo).
- `*Binding.dependencies()` registers everything `lazyPut` in dependency order: datastore → repository → use cases → controller. The controller receives use cases via constructor.
- Controllers extend `GetxController`, expose `.obs` / `Rxn*` state, and never import `data/`.
- Pages use `GetView<Controller>` and wrap only the reactive subtree in `Obx`.

### Routing

Routes are registered centrally:

- `lib/core/routes/app_routes.dart` — string constants (`abstract final class AppRoutes`).
- `lib/core/routes/app_pages.dart` — `GetPage` list with `binding:` attached to every route.
- `lib/main.dart` wires them via `GetMaterialApp(initialRoute: ..., getPages: AppPages.routes)`.

When adding a feature, add a constant to `AppRoutes` and a `GetPage` entry to `AppPages.routes` with the feature's `Binding`.

Use GetX route/sheet helpers (`Get.toNamed`, `Get.back`, `Get.bottomSheet`) instead of `Navigator` / `showModalBottomSheet` for app navigation and modal flow.

### Networking

`lib/core/network/app_api_client.dart` defines `final class AppApiClient extends GetConnect` — currently empty until real networking is needed. When real network calls are introduced, configure `baseUrl`, headers, and auth inside `AppApiClient.onInit()` per `docs/STATE_MANAGEMENT.md` §6, register it once globally with `Get.put(AppApiClient(), permanent: true)` in `main()` (and add `WidgetsFlutterBinding.ensureInitialized()`), and inject it into feature data sources via `Get.find<AppApiClient>()` inside the feature's `Binding`.

The current avatar_filters feature uses an in-memory `FakeAvatarDatastore` instead of the network client — that is the pattern for stubbing data sources before a backend exists.

### Theme & assets

- Theme entrypoints: `lib/core/theme/app_theme.dart`, `app_colors.dart`, `app_text_styles.dart`, `app_font_families.dart`. Always pull colors/typography from these rather than hardcoding.
- The `Italian Plate No2 Expanded` font family is registered with all weights in `pubspec.yaml`. Reference family names through `app_font_families.dart`.
- Avatar PNGs and icons are enumerated in `lib/core/constants/app_assets.dart` (`AppAvatarAssets.*`, `AppIconAssets.*`). When adding new image/icon assets, add them to both `pubspec.yaml` and the matching asset namespace so usages stay typed. Font family names live in `app_font_families.dart`, while font files stay registered in `pubspec.yaml`.

## Conventions to preserve

- Class declarations carry Dart 3 modifiers — e.g. `abstract final class` for static-only namespaces (`AppRoutes`, `AppPages`, `AppAvatarAssets`, `AppIconAssets`), `final class FakeAvatarDatastore implements AvatarDatastore`, etc. When introducing a new type, pick its modifier per `docs/DART_3_CORE_MODIFIERS.md` rather than defaulting to a bare `class`. In particular: domain repository interfaces and data-source abstractions should be `abstract interface class`; entities, models, and DTOs should be `final class`; state unions intended for exhaustive `switch` should be `sealed class`.
- Comments are sparse by design — only add one when intent is non-obvious.
- Do not introduce new state-management, routing, or DI packages. GetX (`get: ^4.7.3`) is the only approved option.
- Localize user-facing production strings with GetX translations: register them in `lib/core/translations/app_translations.dart`, use stable keys, and call `.tr` in widgets instead of hardcoding copy.
- Do not register feature controllers in `main()`; they belong in the feature's `Binding`.
- Tests sit in `test/` mirroring `lib/`. The current suite covers avatar filter domain use cases, `AvatarFiltersEntity` immutability, repository delegation, and the avatar filters page states/interactions.
