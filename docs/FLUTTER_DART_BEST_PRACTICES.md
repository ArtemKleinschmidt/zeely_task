# Flutter & Dart Best Practices for AI Coding Assistants

Use this guide when generating or refactoring Flutter/Dart code.  
Keep code idiomatic, readable, minimal, and consistent with the existing project.

---

## Core Rules

1. **Follow existing project architecture**
   - Do not introduce new architecture, state management, routing, or packages unless explicitly requested.
   - Preserve existing folder structure, naming style, and patterns.

2. **Prefer small widget classes over builder methods**
   - Extract meaningful UI parts into separate `StatelessWidget` / `StatefulWidget` classes.
   - Avoid large `_buildHeader()`, `_buildBody()`, `_buildItem()` methods.
   - Tiny private helper methods are acceptable only when extraction would add noise.

3. **Use `const` whenever possible**
   - Prefer `const` constructors, widgets, paddings, durations, lists, and values when valid.

4. **Use idiomatic constructors**
   - Prefer constructor shorthand:

```dart
const User({
  required this.id,
  required this.name,
});
```

   - Avoid manual field assignment when shorthand works.

5. **Use imports, not fully qualified names**
   - Import packages/files normally.
   - Do not write code like `flutter.widgets.Text` or `material.Scaffold` unless an alias is genuinely needed to resolve a conflict.

6. **Use `final` by default**
   - Local variables, fields, and parameters should be immutable unless reassignment is required.

7. **Keep widgets immutable**
   - Widget fields should usually be `final`.
   - Prefer `const` widget constructors.

8. **Keep business logic out of widgets**
   - Widgets should build UI and dispatch user actions.
   - Move networking, repositories, parsing, validation, filtering, and business rules into the proper layer.

9. **Do not perform side effects in `build`**
   - No API calls, bloc events, navigation, dialogs, or state mutations directly inside `build`.

10. **Dispose resources**
   - Dispose controllers, focus nodes, animation controllers, stream subscriptions, and similar resources.

11. **Check `mounted` after async gaps**
   - Before using `context`, `Navigator`, or `setState` after `await`, check `mounted`.

12. **Prefer explicit public API types**
   - Public methods, fields, parameters, and return values should have explicit types.

13. **Avoid `dynamic`**
   - Use typed models, generics, `Object?`, or DTOs instead.

14. **Separate DTOs from domain/UI models**
   - Do not leak API DTOs into widgets.
   - Use mappers/converters where appropriate.

15. **Use localization for user-facing strings**
   - Do not hardcode visible UI text if the project has localization.

16. **Use theme/design-system values**
   - Prefer `Theme.of(context)`, app text styles, spacing constants, and design tokens over random hardcoded styles.

17. **Avoid unnecessary `Container`**
   - Use `Padding`, `SizedBox`, `DecoratedBox`, `ColoredBox`, `Align`, etc. when only one behavior is needed.

18. **Use `ListView.builder` for large/dynamic lists**
   - Static `children` lists are fine for small fixed layouts.

19. **Handle async errors intentionally**
   - Do not ignore failures.
   - Use the project’s existing error/failure pattern.

20. **Do not spam comments**
   - Do not comment obvious code.
   - Add comments only when code is non-obvious, explains intent, documents a workaround, or gives useful context.
   - Prefer readable code over explanatory comments.

21. **Use Dart 3 class modifiers to express intent**
   - Every class or mixin declaration should choose the most restrictive valid modifier.
   - Prefer a modifier over a bare `class`; only relax it for a real extension or implementation need.
   - Follow `docs/DART_3_CORE_MODIFIERS.md` for the project defaults.

---

## Dart 3 Core Modifiers

The project keeps the Dart 3 modifier policy in a separate guide:

- `docs/DART_3_CORE_MODIFIERS.md` — compact defaults for choosing `abstract final`, `abstract interface`, `final`, `sealed`, `mixin`, and the rarer `base` variants.

---

## Preferred Style Example

```dart
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.user,
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ProfileContent(user: user),
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    required this.user,
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatar(imageUrl: user.avatarUrl),
        const SizedBox(height: 16),
        Text(user.email),
      ],
    );
  }
}
```

---

## Avoid

```dart
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  Widget _buildHeader() {
    return Container(
      child: Text('Profile'),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadUser();

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
        ],
      ),
    );
  }
}
```

Problems:

- missing `const`
- unnecessary builder method
- unnecessary `Container`
- hardcoded user-facing text
- side effect inside `build`
- non-const constructor

---

## Final Checklist

Before returning code, verify:

- Code follows the existing project style.
- No unnecessary abstractions were added.
- Widgets are extracted only when useful.
- `const` and `final` are used where possible.
- Constructors use `this.field` shorthand.
- Imports are clean and normal.
- No side effects happen inside `build`.
- Controllers/resources are disposed.
- Comments are useful and not noisy.
- Code should pass `dart format` and `dart analyze`.
