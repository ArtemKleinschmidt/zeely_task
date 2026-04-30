---
name: unit-tests
description: Generate mocktail-based unit tests for a Dart class or folder. Accepts a class name, file path, or directory path as the argument. Use when the user asks to write, generate, or add unit tests.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Bash(find *)
  - Bash(grep *)
  - Bash(fvm flutter test *)
---

# /unit-tests — Generate Unit Tests

Arguments passed: `$ARGUMENTS`

Generate well-structured, mocktail-based unit tests for a Dart class or a folder of classes in this Flutter project.

---

## Step 1 — Locate the source file(s)

Parse `$ARGUMENTS`:

- If it contains `/` or ends in `.dart`, treat it as a file or directory path.
- Otherwise, treat it as a class name: find the file with `find lib/ -name "*.dart"` and `grep -l "class $ARGUMENTS"`.
- For a directory, collect all `.dart` files in it recursively.

Read each source file before generating tests.

---

## Step 2 — Analyse the class

From the source file, determine:

- **Layer** — inferred from path segment: `domain/entities/`, `domain/usecases/`, `data/datasources/`, `data/repositories/`, `presentation/controllers/`
- **Constructor dependencies** — these are what gets mocked
- **Public API** — methods and properties that will be exercised in tests

---

## Step 3 — Determine what to mock

| Layer | Mock |
|---|---|
| Entity / value object | Nothing — construct directly |
| Pure use case (no constructor deps) | Nothing |
| Use case with dependencies | The domain repository/service **interface** |
| Repository impl | The data source **interface** |
| Controller | The use cases injected via constructor |

Always mock the **interface**, never the concrete implementation. Define one `class Mock<Type> extends Mock implements <Type> {}` per mocked type at the top of the test file.

For controllers: call `Get.put(controller)` in `setUp` and `Get.reset()` in `tearDown` to keep GetX state isolated between tests.

---

## Step 4 — Write the test file

**Destination**: mirror `lib/` → `test/`, appending `_test` before `.dart`:
```
lib/features/avatar_filters/domain/usecases/get_avatars_use_case.dart
→ test/features/avatar_filters/domain/usecases/get_avatars_use_case_test.dart
```

If the test file already exists, report it and stop — do not overwrite.

---

## Best practices

### Scope
- One behavior per `test()` — each block asserts exactly one observable outcome.
- Use `group()` to cluster related tests (e.g. one group per method or scenario).

### Naming
- Test names are declarative sentences: `'returns only male avatars when gender filter is active'`.
- Never use vague names like `'test'`, `'works'`, or `'it filters'`.

### Structure (AAA)
- Arrange, Act, Assert — separated by blank lines within each test.
- Use `setUp` to avoid repeating initialization, but keep each test readable on its own.

### Test data
- Use only the data the test actually needs. Hard-code expected values.
- Introduce a local factory helper only when the same object shape appears in three or more tests.

### Mocking
- Stub only what the test exercises.
- Prefer concrete argument values over `any()` when the value is known.
- Use `verify(...)` only when the test's purpose is to confirm a delegation — not as a reflex.

### Coverage
- Cover the happy path, at least one edge case (empty input, boundary value, no matches), and exception propagation where relevant.
- Test observable behavior through the public API only — never test private methods.

---

## Step 5 — Run and fix

After writing the test file, run:

```bash
fvm flutter test <test_file_path>
```

If it fails to compile or a test fails, read the error, fix the file, and re-run. Report the final pass/fail result.
If you can't fix failing tests or compilation errors after 5 interactions, stop and report back.
