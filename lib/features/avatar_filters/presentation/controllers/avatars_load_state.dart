import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';

sealed class AvatarsLoadState {
  const AvatarsLoadState();
}

final class AvatarsLoading extends AvatarsLoadState {
  const AvatarsLoading();
}

final class AvatarsLoaded extends AvatarsLoadState {
  const AvatarsLoaded(this.avatars);

  final List<AvatarEntity> avatars;
}

final class AvatarsLoadFailed extends AvatarsLoadState {
  const AvatarsLoadFailed(this.error);

  final Object error;
}
