# Zeely Task

Flutter avatar filtering task app built with GetX and Clean Architecture.

## Stack

- Flutter `3.38.9` via FVM
- Dart `^3.9.2`
- GetX
- `flutter_svg`
- `flutter_test` and `mocktail`

## Setup

```bash
fvm install
fvm flutter pub get
```

## Run

```bash
fvm flutter run
```

## Checks

```bash
fvm dart format lib test
fvm flutter analyze
fvm flutter test
```

## Structure

```text
lib/
  core/                    Shared routes, theme, translations, assets, widgets
  features/avatar_filters/
    data/                  Datasources, models, repository implementation
    domain/                Entities, repository contracts, use cases
    presentation/          GetX binding and controller
    ui/                    Page and widgets
test/
  features/avatar_filters/ Tests mirroring the feature structure
```

The project follows:

```text
UI -> Presentation -> Domain <- Data
```

See `CLAUDE.md` and `docs/` for the full project rules.
