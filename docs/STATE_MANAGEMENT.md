# GetX Clean Architecture Megaguide — State Management

## Scope

This file defines the required GetX patterns for reactive state management, dependency injection, routing, localization, services, lifecycle, workers, and UI binding.

Use this file for GetX-specific implementation details.

For layer definitions, dependency boundaries, Clean Architecture rules, and SOLID principles, see `ARCHITECTURE.md`.

---

## 1. GetX Usage Rules

The application uses GetX for:

```text
Reactive state management
Dependency injection
Route management
Localization
Global services
Controller lifecycle
Workers for reactive side effects
```

Required package line:

```yaml
dependencies:
  get: ^4.7.3
```

---

## 2. Reactive State Rules

Use GetX reactive types for screen state.

```dart
final isLoading = false.obs;
final errorMessage = RxnString();
final user = Rxn<UserEntity>();
final users = <UserEntity>[].obs;
```

Rules:

```text
Use .obs for non-null primitive state.
Use Rxn<T> for nullable object state.
Use RxnString for nullable string state.
Use RxList<T> for reactive lists.
Use Obx in UI to react to Rx state.
```

---

## 3. Controller Pattern

Controllers own presentation state and call use cases.

```dart
import 'package:get/get.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';

class UserController extends GetxController {
  final GetUserProfileUseCase getUserProfileUseCase;

  UserController(this.getUserProfileUseCase);

  final user = Rxn<UserEntity>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchUser(1);
  }

  Future<void> fetchUser(int id) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      user.value = await getUserProfileUseCase.execute(id);
    } catch (error) {
      errorMessage.value = error.toString();
      Get.snackbar('Error', error.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
```

Rules:

```text
Controller extends GetxController.
Controller exposes Rx state.
Controller calls use cases only.
Controller does not import data layer.
Controller does not call data sources.
Controller does not parse JSON.
Controller does not build widgets.
```

---

## 4. UI Binding with GetView and Obx

Pages should use `GetView<Controller>` for typed controller access.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/user_controller.dart';

class UserPage extends GetView<UserController> {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile_title'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final error = controller.errorMessage.value;

        if (error != null) {
          return Center(
            child: Text(error),
          );
        }

        final data = controller.user.value;

        if (data == null) {
          return const Center(
            child: Text('No data'),
          );
        }

        return Center(
          child: Text(data.name),
        );
      }),
    );
  }
}
```

Rules:

```text
Use GetView<Controller> for pages.
Use Obx only around widgets that read Rx values.
Do not wrap the entire screen in Obx when only one widget changes.
Do not call repositories from widgets.
Do not parse API responses in widgets.
```

---

## 5. Bindings and Dependency Injection

Use Bindings to wire feature dependencies.

```dart
import 'package:get/get.dart';

import '../../../../core/network/app_api_client.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSource(Get.find<AppApiClient>()),
    );

    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(Get.find<UserRemoteDataSource>()),
    );

    Get.lazyPut<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(Get.find<UserRepository>()),
    );

    Get.lazyPut<UserController>(
      () => UserController(Get.find<GetUserProfileUseCase>()),
    );
  }
}
```

Rules:

```text
Bindings wire dependencies for a route.
Use Get.lazyPut for route-scoped dependencies.
Register abstractions using the domain interface type.
Controller receives use cases through constructor injection.
Do not register feature controllers globally in main().
Do not create controllers manually inside widgets.
```

---

## 6. Global GetConnect Client

Use one global API client for shared network configuration.

```dart
import 'package:get/get.dart';

class AppApiClient extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.example.com';

    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      return request;
    });

    httpClient.addAuthenticator<dynamic>((request) async {
      final token = await _getAccessToken();

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      return request;
    });

    httpClient.maxAuthRetries = 3;

    super.onInit();
  }

  Future<String?> _getAccessToken() async {
    return null;
  }
}
```

Rules:

```text
Global base URL belongs in AppApiClient.
Global headers belong in AppApiClient.
Auth header injection belongs in AppApiClient.
Feature data sources use AppApiClient.
Feature controllers do not use AppApiClient directly.
```

---

## 7. Routes

Route names belong in `AppRoutes`.

```dart
abstract class AppRoutes {
  static const user = '/user';
}
```

Pages belong in `AppPages`.

```dart
import 'package:get/get.dart';

import '../../features/user/presentation/bindings/user_binding.dart';
import '../../features/user/ui/pages/user_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.user,
      page: () => const UserPage(),
      binding: UserBinding(),
    ),
  ];
}
```

Rules:

```text
Use GetPage for route registration.
Use AppRoutes for route constants.
Use AppPages for page definitions.
Attach a Binding to each feature route.
Use Get.toNamed, Get.offNamed, and Get.offAllNamed for navigation.
Do not use BuildContext for navigation.
```

---

## 8. Translations

```dart
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'en_US': {
        'profile_title': 'User Profile',
      },
      'uk_UA': {
        'profile_title': 'Профіль користувача',
      },
    };
  }
}
```

Usage:

```dart
Text('profile_title'.tr)
```

Rules:

```text
Use .tr in UI widgets.
Keep translation keys stable.
Do not hardcode user-facing production strings in widgets.
Register translations in GetMaterialApp.
```

---

## 9. Services

Use `GetxService` for app-wide dependencies that must live for the full app lifecycle.

Examples:

```text
AuthService
StorageService
DatabaseService
AnalyticsService
SettingsService
```

### Auth Service

```dart
import 'package:get/get.dart';

class AuthService extends GetxService {
  final isAuthenticated = false.obs;

  Future<AuthService> init() async {
    isAuthenticated.value = false;
    return this;
  }

  void login() {
    isAuthenticated.value = true;
  }

  void logout() {
    isAuthenticated.value = false;
  }
}
```

### Storage Service

```dart
import 'package:get/get.dart';

class StorageService extends GetxService {
  Future<StorageService> init() async {
    return this;
  }
}
```

### Service Initialization

```dart
import 'package:get/get.dart';

import 'auth_service.dart';
import 'storage_service.dart';

Future<void> initServices() async {
  await Get.putAsync<StorageService>(
    () => StorageService().init(),
  );

  await Get.putAsync<AuthService>(
    () => AuthService().init(),
  );
}
```

Rules:

```text
Services extend GetxService.
Services are initialized before runApp().
Services are registered with Get.putAsync when async initialization is needed.
Services are app-scoped, not route-scoped.
Services are not feature controllers.
```

---

## 10. Main App Initialization

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/network/app_api_client.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/services/init_services.dart';
import 'core/theme/app_theme.dart';
import 'core/translations/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  Get.put<AppApiClient>(
    AppApiClient(),
    permanent: true,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetX Clean Architecture App',
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: AppRoutes.user,
      getPages: AppPages.pages,
    );
  }
}
```

Rules:

```text
Call WidgetsFlutterBinding.ensureInitialized().
Initialize GetxService dependencies before runApp().
Register AppApiClient globally.
Use GetMaterialApp.
Use AppPages for routes.
Use AppTranslations for localization.
```

---

## 11. Worker Pattern for Search

Use GetX workers for reactive side effects.

Search must use `debounce` inside the controller.

```dart
import 'package:get/get.dart';

class SearchController extends GetxController {
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final results = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    debounce<String>(
      searchQuery,
      (query) {
        performSearch(query);
      },
      time: const Duration(milliseconds: 500),
    );
  }

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      results.clear();
      return;
    }

    isLoading.value = true;

    try {
      results.assignAll([
        'Result for $query',
      ]);
    } finally {
      isLoading.value = false;
    }
  }
}
```

UI usage:

```dart
TextField(
  onChanged: (value) {
    controller.searchQuery.value = value;
  },
)
```

Rules:

```text
Use debounce for search fields.
Register workers in onInit().
Do not debounce inside widgets.
Do not call APIs directly from TextField.onChanged.
TextField.onChanged only updates searchQuery.value.
```

---

## 12. Other Worker Rules

Use workers for controller-owned reactive side effects.

```text
ever      = run every time an Rx value changes
once      = run only the first time an Rx value changes
debounce  = run after changes stop for a duration
interval  = run at most once per duration while changes happen
everAll   = run when any Rx value in a list changes
```

Rules:

```text
Workers belong in controllers.
Workers are registered in onInit().
Workers must not be registered in build().
Use debounce for search.
Use interval for rate-limited repeated actions.
Use ever for simple reactions to state changes.
```

---

## 13. Resource Cleanup

Controllers must clean up owned resources.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();

  @override
  void onClose() {
    nameController.dispose();
    nameFocusNode.dispose();
    super.onClose();
  }
}
```

Rules:

```text
Dispose TextEditingController in onClose().
Dispose FocusNode in onClose().
Close custom streams in onClose().
Cancel manual subscriptions in onClose().
Do not dispose dependencies owned by GetX DI manually.
```

---

## 14. Error State Pattern

Use simple controller-level error state.

```dart
final errorMessage = RxnString();
```

During requests:

```dart
try {
  errorMessage.value = null;
  // call use case
} catch (error) {
  errorMessage.value = error.toString();
  Get.snackbar('Error', error.toString());
}
```

Rules:

```text
Controller owns presentation error state.
Repository throws errors.
UI displays controller.errorMessage.
Use snackbar only for user-visible transient errors.
```

---

## 15. Performance Rules

| Rule | Implementation |
|---|---|
| Atomic updates | Wrap only the widget that reads Rx state in `Obx`. |
| Lazy dependencies | Use `Get.lazyPut` for route-scoped dependencies. |
| App services | Use `GetxService` for long-running app-wide services. |
| Search input | Use `debounce` worker in controller. |
| Cleanup | Dispose owned resources in `onClose`. |
| List updates | Use `assignAll`, `add`, `remove`, or `refresh` when needed. |
| Navigation | Use named routes registered in `AppPages`. |

---

## 16. AI Code Generation Rules

When generating GetX code, follow these rules exactly.

| Area | Rule |
|---|---|
| State management | Use `.obs`, `Rxn<T>`, `RxnString`, `RxList<T>`, and `Obx`. |
| Controllers | Extend `GetxController`. |
| Services | Extend `GetxService`. |
| Dependency injection | Use `Bindings` and `Get.lazyPut` for feature dependencies. |
| Global services | Use `Get.putAsync` or `Get.put(..., permanent: true)` for app-wide dependencies. |
| Navigation | Use `GetPage`, `AppRoutes`, and `AppPages`. |
| Localization | Use `Translations` and `.tr`. |
| API client | Use `GetConnect` through a global `AppApiClient`. |
| Data source | Data source calls APIs and returns raw response or DTO. |
| UI | UI reads controller state only. |
| Cleanup | Dispose resources in `onClose()`. |
| Search | Use `debounce` worker in controller. |

---

## 17. Forbidden GetX Patterns

Do not generate these patterns:

```text
Do not call API directly from UI.
Do not inject repositories directly into UI.
Do not parse JSON in controllers.
Do not parse JSON in widgets.
Do not use BuildContext for navigation.
Do not put business logic in widgets.
Do not register feature controllers globally in main().
Do not create controllers manually with constructors inside widgets.
Do not wrap the entire screen in Obx when only one widget changes.
Do not use Get.put for route-scoped feature dependencies when Binding + Get.lazyPut is expected.
Do not register workers in build().
Do not call APIs directly from TextField.onChanged.
```
