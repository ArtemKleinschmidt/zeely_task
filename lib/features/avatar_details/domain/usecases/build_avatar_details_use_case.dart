import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';

import '../entities/avatar_details_entity.dart';

abstract interface class BuildAvatarDetailsUseCase {
  AvatarDetailsEntity call(AvatarEntity avatar);
}

final class BuildAvatarDetailsUseCaseImpl implements BuildAvatarDetailsUseCase {
  const BuildAvatarDetailsUseCaseImpl();

  @override
  AvatarDetailsEntity call(AvatarEntity avatar) {
    return AvatarDetailsEntity.fromAvatar(avatar);
  }
}
