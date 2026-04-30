import '../../domain/entities/avatar_entity.dart';
import '../../domain/repositories/avatar_repository.dart';
import '../datasources/avatar_datastore.dart';

final class AvatarRepositoryImpl implements AvatarRepository {
  const AvatarRepositoryImpl(this.datastore);

  final AvatarDatastore datastore;

  @override
  Future<List<AvatarEntity>> getAvatars() async {
    final avatars = await datastore.getAvatars();

    return avatars.map((avatar) => avatar.toEntity()).toList(growable: false);
  }
}
