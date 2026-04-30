import '../entities/avatar_entity.dart';

abstract interface class AvatarRepository {
  Future<List<AvatarEntity>> getAvatars();
}
