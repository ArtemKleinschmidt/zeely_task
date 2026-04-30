import 'package:get/get.dart';

import '../../features/avatar_filters/presentation/bindings/avatar_filters_binding.dart';
import '../../features/avatar_filters/ui/pages/avatar_filters_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.avatarFilters,
      page: () => const AvatarFiltersPage(),
      binding: AvatarFiltersBinding(),
    ),
  ];
}
