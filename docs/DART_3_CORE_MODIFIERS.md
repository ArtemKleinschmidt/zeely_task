# Dart 3 Core Modifiers

Pick the most restrictive modifier that still fits the type's real use.
Prefer making extension and implementation explicit, not accidental.

## Default Choices

| Use case | Modifier |
|---|---|
| Static-only namespace | `abstract final class` |
| Repository or data-source contract | `abstract interface class` |
| Entity, model, DTO, or other closed concrete type | `final class` |
| Exhaustive state/result hierarchy | `sealed class` |
| Shared behavior mixed in with `with` | `mixin` |
| Shared implementation that must be inherited | `base` / `abstract base` |

## Short Reference

| Modifier | Use when |
|---|---|
| `abstract` | The type is a contract or partial implementation and should not be instantiated. |
| `base` | Subtypes must inherit implementation, not just implement an API. |
| `interface` | Consumers should `implements`, not `extends`. |
| `final` | The type should stay closed to subclassing and implementation outside its library. |
| `sealed` | All subtypes should stay in the same library for exhaustive `switch` handling. |
| `mixin` | The code is reusable behavior applied with `with`. |
| `mixin class` | Rare; only when the same declaration truly must work as both class and mixin. |
| `abstract base` | Abstract shared implementation that must be extended. |
| `abstract interface` | Pure contract that should only be implemented. |
| `abstract final` | Static-only namespace with no instances or subtypes. |

## Rules

- Do not use a bare `class` when a modifier expresses the intent more clearly.
- Do not combine modifiers redundantly; `sealed` already implies `abstract final`.
- Prefer `mixin` over `mixin class` unless instances are genuinely needed.

## Project Defaults

```dart
abstract final class AppRoutes {}
abstract interface class AvatarRepository {}
final class AvatarModel {}
sealed class AvatarLoadState {}
mixin LoadingState {}
```
