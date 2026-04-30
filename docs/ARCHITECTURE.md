# GetX Clean Architecture Megaguide — Architecture

## Scope

This file defines the required Clean Architecture structure, layer responsibilities, dependency rules, and SOLID principles for Flutter applications that use GetX.

Use this file for architectural decisions, folder generation, dependency boundaries, and feature scaffolding.

For GetX-specific reactive state, controller lifecycle, dependency injection, routing, workers, and services, see `STATE_MANAGEMENT.md`.

---

## 1. Core Principle

The application must follow strict separation of concerns.

```text
UI → Presentation → Domain ← Data
```

The Domain layer is the center of the application. It contains business rules and must remain independent from frameworks, UI, databases, APIs, and platform-specific code.

---

## 2. Layer Responsibilities

| Layer | Responsibility | Allowed Dependencies | Forbidden Dependencies |
|---|---|---|---|
| UI | Render widgets and user interaction only | Flutter, GetX view utilities, Presentation | Domain logic, Data, API, storage |
| Presentation | Controllers, state, bindings, UI orchestration | GetX, Domain | Data sources, DTO parsing, direct API calls |
| Domain | Entities, repository interfaces, use cases | Pure Dart only | Flutter, GetX, HTTP, databases, platform APIs |
| Data | Repository implementations, data sources, DTOs, mappers | Domain, API clients, storage, platform integrations | UI, Presentation |
| Core | Global app configuration | Depends on purpose | Feature business logic |

---

## 3. Project Structure

```text
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── translations/
│   │   └── app_translations.dart
│   ├── network/
│   │   └── app_api_client.dart
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── services/
│       ├── auth_service.dart
│       └── storage_service.dart
│
├── features/
│   └── user/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── user_remote_data_source.dart
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   └── repositories/
│       │       └── user_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_entity.dart
│       │   ├── repositories/
│       │   │   └── user_repository.dart
│       │   └── usecases/
│       │       └── get_user_profile_usecase.dart
│       │
│       ├── presentation/
│       │   ├── bindings/
│       │   │   └── user_binding.dart
│       │   └── controllers/
│       │       └── user_controller.dart
│       │
│       └── ui/
│           ├── pages/
│           │   └── user_page.dart
│           └── widgets/
│
└── main.dart
```

Directory meaning:

```text
core/         = global app configuration, routing, services, theme, translations
features/     = isolated business modules
data/         = infrastructure and external systems
domain/       = pure Dart business logic
presentation/ = GetX controllers and bindings
ui/           = Flutter widgets only
```

---

## 4. Domain Layer

The Domain layer contains the application truth.

It must contain:

```text
Entities
Repository interfaces
Use cases
Domain-specific value objects, when needed
```

It must not import:

```dart
import 'package:flutter/...';
import 'package:get/...';
import 'package:http/...';
```

### Entity

```dart
class UserEntity {
  final int id;
  final String name;
  final String email;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}
```

Rules:

```text
Entity represents domain data.
Entity is not an API response model.
Entity is not a database object.
Entity must not contain JSON parsing.
Entity must not depend on GetX or Flutter.
```

### Repository Interface

```dart
abstract class UserRepository {
  Future<UserEntity> getUserProfile(int id);
}
```

Rules:

```text
Repository interface defines what the feature needs.
Repository interface does not define how data is fetched.
Repository interface belongs to Domain.
Repository implementation belongs to Data.
Use clear Dart names such as UserRepository, not IUserRepository.
```

### Use Case

```dart
class GetUserProfileUseCase {
  final UserRepository repository;

  const GetUserProfileUseCase(this.repository);

  Future<UserEntity> call(int id) {
    return repository.getUserProfile(id);
  }
}
```

Rules:

```text
Use case is the entry point into Domain logic.
Use case depends on repository interface only.
Use case contains business rules and orchestration.
Controller calls use case.
Use case does not call data source directly.
```

---

## 5. Data Layer

The Data layer implements Domain contracts and handles infrastructure.

It contains:

```text
Remote data sources
Local data sources
DTO models
Repository implementations
Mappers
Platform adapters
```

### Model / DTO

```dart
import '../../domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
    );
  }
}
```

Rules:

```text
Model represents API or local-storage shape.
Entity represents domain shape.
Model converts to Entity.
Entity does not know about Model.
JSON parsing belongs to Model or Mapper.
```

### Remote Data Source

```dart
import 'package:get/get.dart';

import '../../../../core/network/app_api_client.dart';

class UserRemoteDataSource {
  final AppApiClient apiClient;

  const UserRemoteDataSource(this.apiClient);

  Future<Response<dynamic>> getUser(int id) {
    return apiClient.get('/users/$id');
  }
}
```

Rules:

```text
Data source performs raw API calls.
Data source returns raw response or DTO.
Data source does not return Entity.
Data source does not contain business logic.
Data source does not update UI state.
```

### Repository Implementation

```dart
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  const UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> getUserProfile(int id) async {
    final response = await remoteDataSource.getUser(id);

    if (response.status.hasError) {
      throw Exception(response.statusText ?? 'Failed to load user profile');
    }

    final body = response.body;

    if (body is! Map<String, dynamic>) {
      throw Exception('Invalid user response format');
    }

    final model = UserModel.fromJson(body);
    return model.toEntity();
  }
}
```

Rules:

```text
RepositoryImpl implements Domain repository interface.
RepositoryImpl calls data sources.
RepositoryImpl maps models to entities.
RepositoryImpl handles infrastructure errors.
RepositoryImpl does not expose DTOs to Domain or UI.
```

---

## 6. UI Layer

The UI layer contains pages and widgets.

Rules:

```text
UI renders state from controller.
UI sends user events to controller.
UI does not contain business logic.
UI does not call use cases directly.
UI does not call repositories.
UI does not call data sources.
UI does not parse JSON.
```

Allowed example:

```dart
TextField(
  onChanged: (value) {
    controller.searchQuery.value = value;
  },
)
```

Forbidden example:

```dart
TextField(
  onChanged: (value) async {
    final response = await api.get('/users?query=$value');
  },
)
```

---

## 7. Presentation Layer Boundary

The Presentation layer owns UI state and UI orchestration.

It may contain:

```text
Controllers
Bindings
Presentation-only state classes
```

Rules:

```text
Controller calls use cases only.
Controller owns loading, error, and screen state.
Controller does not parse JSON.
Controller does not know API endpoints.
Controller does not know database tables.
Controller does not build widgets.
```

---

## 8. Core Layer

The Core layer contains global infrastructure and configuration.

It may contain:

```text
Theme
Routing
Translations
Network client
Global services
Constants
Environment configuration
```

Rules:

```text
Core may be used by features.
Core must not contain feature-specific business logic.
Core must not depend on feature internals unless defining route registration.
```

---

## 9. SOLID Principles

### Single Responsibility Principle

Each class has exactly one reason to change.

```text
Entity changes when domain data changes.
Use case changes when business rule changes.
Data source changes when API call changes.
RepositoryImpl changes when data mapping or data source coordination changes.
Controller changes when screen behavior changes.
Widget changes when UI layout changes.
```

### Open/Closed Principle

Code should be open for extension and closed for modification.

Required pattern:

```text
Domain depends on abstract repository.
Data provides implementation.
New data source can be added without changing use case.
```

### Liskov Substitution Principle

Repository implementations must be replaceable without breaking Domain logic.

```text
UserRepositoryImpl must satisfy UserRepository contract.
MockUserRepository must satisfy UserRepository contract.
CachedUserRepository must satisfy UserRepository contract.
```

### Interface Segregation Principle

Repository interfaces must stay focused.

Good:

```dart
abstract class UserRepository {
  Future<UserEntity> getUserProfile(int id);
}
```

Bad:

```dart
abstract class AppRepository {
  Future<UserEntity> getUserProfile(int id);
  Future<void> login();
  Future<void> syncOrders();
  Future<void> uploadAvatar();
}
```

Rules:

```text
Do not create giant repositories.
Split repositories by feature or domain concept.
Expose only methods required by use cases.
```

### Dependency Inversion Principle

High-level policy must not depend on low-level implementation.

Required dependency direction:

```text
UseCase → Repository interface
RepositoryImpl → Repository interface
Controller → UseCase
```

Forbidden dependency direction:

```text
UseCase → RepositoryImpl
UseCase → RemoteDataSource
Domain → GetConnect
Domain → Flutter
```

---

## 10. Naming Rules

```text
Entity:                 UserEntity
Repository interface:   UserRepository
Repository impl:        UserRepositoryImpl
Remote data source:     UserRemoteDataSource
Local data source:      UserLocalDataSource
Model / DTO:            UserModel
Use case:               GetUserProfileUseCase
Controller:             UserController
Binding:                UserBinding
Page:                   UserPage
Widget:                 UserAvatar
```

Rules:

```text
Do not use IUserRepository.
Do not use vague names such as Manager, Helper, Handler, or Utils for business logic.
Use feature-specific names.
Use explicit use case names.
```

---

## 11. Required Feature Flow

```text
UserPage
  ↓ reads state from
UserController
  ↓ calls
GetUserProfileUseCase
  ↓ depends on
UserRepository
  ↑ implemented by
UserRepositoryImpl
  ↓ calls
UserRemoteDataSource
  ↓ uses
AppApiClient / GetConnect
```

Every feature must follow this flow.

---

## 12. Architecture Rules for AI Code Generation

When generating code, follow these rules exactly.

| Area | Rule |
|---|---|
| Feature structure | Generate `data`, `domain`, `presentation`, and `ui` folders. |
| Domain | Generate entities, repository interfaces, and use cases. |
| Data | Generate data sources, models, mappers, and repository implementations. |
| Presentation | Generate controllers and bindings. |
| UI | Generate pages and widgets only. |
| Dependency direction | Preserve `UI → Presentation → Domain ← Data`. |
| Repository abstraction | Use abstract repository in Domain. |
| Repository implementation | Implement repository in Data. |
| DTO mapping | Convert DTOs/models to entities before returning to Domain or Presentation. |
| Business logic | Put business logic in use cases, not widgets. |
| Framework isolation | Keep Flutter and GetX out of Domain. |

---

## 13. Forbidden Architecture Patterns

Do not generate these patterns:

```text
Do not call API directly from UI.
Do not inject repositories directly into UI.
Do not parse JSON in controllers.
Do not parse JSON in widgets.
Do not import GetX in Domain.
Do not import Flutter in Domain.
Do not put business logic in widgets.
Do not create giant repositories.
Do not expose DTOs outside Data.
Do not return API models from use cases.
Do not put feature-specific logic in Core.
Do not make Domain depend on Data.
```
