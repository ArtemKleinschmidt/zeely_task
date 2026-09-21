import '../models/avatar_model.dart';

abstract interface class AvatarDatastore {
  Future<List<AvatarModel>> getAvatars();
}
