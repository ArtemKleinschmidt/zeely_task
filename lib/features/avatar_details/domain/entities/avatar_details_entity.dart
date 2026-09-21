import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_flavor.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';

final class AvatarDetailsEntity {
  const AvatarDetailsEntity({
    required this.avatarId,
    required this.name,
    required this.imagePath,
    required this.gender,
    required this.age,
    required this.scoreLabel,
    required this.flavors,
    required this.description,
  });

  final String avatarId;
  final String name;
  final String imagePath;
  final Gender gender;
  final int age;
  final String scoreLabel;
  final List<AvatarFlavor> flavors;
  final String description;

  factory AvatarDetailsEntity.fromAvatar(AvatarEntity avatar) {
    return AvatarDetailsEntity(
      avatarId: avatar.id,
      name: avatar.fullName,
      imagePath: avatar.imagePath,
      gender: avatar.gender,
      age: avatar.age,
      scoreLabel: avatar.scoreLabel,
      flavors: avatar.flavors,
      description: avatar.description,
    );
  }
}
