import '../entities/avatar_entity.dart';
import '../repositories/avatar_repository.dart';

abstract interface class GetAvatarsUseCase {
  Future<List<AvatarEntity>> call();
}

final class GetAvatarsUseCaseImpl implements GetAvatarsUseCase {
  const GetAvatarsUseCaseImpl(this.repository);

  final AvatarRepository repository;

  @override
  Future<List<AvatarEntity>> call() {
    return repository.getAvatars();
  }
}
