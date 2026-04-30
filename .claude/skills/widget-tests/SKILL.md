---
name: widget-tests
description: Generate widget tests for a Flutter widget or page. Accepts a widget class name, file path, or directory path as the argument. Use when the user asks to write, generate, or add widget tests.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Bash(find *)
  - Bash(grep *)
  - Bash(fvm flutter test *)
---

# /widget-tests — Generate Widget Tests

Arguments passed: `$ARGUMENTS`

Generate well-structured widget tests for a Flutter widget or page in this project.

---

## Testing stack

This project uses `flutter_test` (built-in) for widget testing and `mocktail` (already in `pubspec.yaml`) for mocking GetX controllers. No additional library is required for isolated widget tests.

> **If richer finder syntax or native-interaction support is needed later**, [`patrol`](https://pub.dev/packages/patrol) by LeanCode is the most widely adopted Flutter testing library for those scenarios — but do not add it unless the user asks.

---

## Step 1 — Locate the source file(s)

Parse `$ARGUMENTS`:

- If it contains `/` or ends in `.dart`, treat it as a file or directory path.
- Otherwise, locate the file with `find lib/ -name "*.dart"` and `grep -l "class $ARGUMENTS"`.
- For a directory, collect all `.dart` files in it recursively. Skip files that are clearly not widgets (e.g. entities, use cases, controllers, bindings).

Read each source file before generating tests.

---

## Step 2 — Classify the widget

Determine which test setup pattern applies:

| Widget type | How to identify | Setup needed |
|---|---|---|
| **Standalone widget** | Constructor only accepts plain values/callbacks, no GetX dependency | Wrap in `MaterialApp` and pass props directly |
| **GetView page** | Extends `GetView<SomeController>` | Wrap in `GetMaterialApp`, mock and register the controller via `Get.put` before pumping |

Read the widget's constructor and imports to decide which case applies.

---

## Step 3 — Mock the controller (GetView pages only)

Create a mock for the controller using mocktail:

```dart
class MockAvatarFiltersController extends GetxController
    with Mock
    implements AvatarFiltersController {}
```

In `setUp`, register it with GetX and stub the reactive state properties the widget reads. In `tearDown`, call `Get.reset()`.

Stub only the state the widget under test actually accesses — do not stub everything on the controller.

---

## Step 4 — Test file destination

Mirror `lib/` → `test/`, appending `_test` before `.dart`:
```
lib/features/avatar_filters/ui/widgets/avatar_filter_chip.dart
→ test/features/avatar_filters/ui/widgets/avatar_filter_chip_test.dart
```

If the test file already exists, report it and stop — do not overwrite.

---

## Best practices

### Scope
- One behavior per `testWidgets` block — each test asserts one observable UI outcome.
- Use `group()` to cluster related tests (e.g. one group for rendering, one for interactions).

### Naming
- Test names are declarative sentences describing what the user sees or experiences: `'shows count badge when count is greater than zero'`.
- Avoid vague names like `'renders correctly'` or `'widget test'`.

### Pumping
- Use `tester.pumpAndSettle()` after interactions that trigger animations or async updates.
- Use `tester.pump()` when you only need a single frame (no pending timers or animations).
- When a widget has ongoing animations you don't want to wait on, pump with a specific duration.

### Finding widgets
- Prefer semantic finders: `find.text(...)`, `find.byType(...)`, `find.byKey(...)`.
- Use `find.byKey` with `ValueKey` / `Key` only when text or type alone is ambiguous.
- Avoid relying on widget tree depth or index-based finders.

### Interactions
- `tester.tap(finder)` for taps; always `pump` or `pumpAndSettle` after.
- `tester.enterText(finder, text)` for text input.
- For callbacks passed as constructor arguments, use a simple tracking variable (`var tapped = false`) — no mock needed.

### Assertions
- `findsOneWidget`, `findsNothing`, `findsNWidgets(n)` for presence checks.
- Check text content, not widget structure, wherever possible.
- Do not assert on exact colors, padding, or layout measurements — those are fragile and belong in golden tests.

### Data
- Use minimal, hard-coded test data. Do not import or call production fake data sources.
- For widgets that need `AvatarEntity` instances, construct them inline with only the fields the widget renders.

---

## Step 5 — Run and fix

After writing the test file, run:

```bash
fvm flutter test <test_file_path>
```

If it fails to compile or a test fails, read the error, fix the file, and re-run. Report the final pass/fail result.
If you can't fix failing tests or compilation errors after 5 interactions, stop and report back.
