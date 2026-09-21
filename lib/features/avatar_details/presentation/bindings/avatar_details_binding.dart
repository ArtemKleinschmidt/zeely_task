import 'package:get/get.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';

import '../../domain/usecases/build_avatar_details_use_case.dart';
import '../controllers/avatar_details_controller.dart';

final class AvatarDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuildAvatarDetailsUseCase>(
      () => const BuildAvatarDetailsUseCaseImpl(),
    );

    Get.lazyPut<AvatarDetailsController>(
      () => AvatarDetailsController(
        avatar: Get.arguments as AvatarEntity,
        buildAvatarDetailsUseCase: Get.find<BuildAvatarDetailsUseCase>(),
      ),
    );
  }
}
