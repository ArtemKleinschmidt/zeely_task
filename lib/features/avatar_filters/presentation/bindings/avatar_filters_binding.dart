import 'package:get/get.dart';

import '../../data/datasources/avatar_datastore.dart';
import '../../data/datasources/fake_avatar_datastore.dart';
import '../../data/repositories/avatar_repository_impl.dart';
import '../../domain/repositories/avatar_repository.dart';
import '../../domain/usecases/apply_avatar_filters_use_case.dart';
import '../../domain/usecases/get_avatars_use_case.dart';
import '../controllers/avatar_filters_controller.dart';

final class AvatarFiltersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvatarDatastore>(() => const FakeAvatarDatastore());

    Get.lazyPut<AvatarRepository>(
      () => AvatarRepositoryImpl(Get.find<AvatarDatastore>()),
    );

    Get.lazyPut<GetAvatarsUseCase>(
      () => GetAvatarsUseCaseImpl(Get.find<AvatarRepository>()),
    );

    Get.lazyPut<ApplyAvatarFiltersUseCase>(
      () => const ApplyAvatarFiltersUseCase(),
    );

    Get.lazyPut<AvatarFiltersController>(
      () => AvatarFiltersController(
        getAvatarsUseCase: Get.find<GetAvatarsUseCase>(),
        applyAvatarFiltersUseCase: Get.find<ApplyAvatarFiltersUseCase>(),
      ),
    );
  }
}
