import '../../domain/entities/avatar_entity.dart';
import '../../domain/entities/avatar_gender.dart';
import '../../domain/entities/avatar_pose.dart';

final class AvatarModel {
  const AvatarModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.imagePath,
    required this.gender,
    required this.age,
    required this.pose,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String imagePath;
  final Gender gender;
  final int age;
  final Pose pose;

  String get fullName => '$firstName $lastName';

  AvatarEntity toEntity() {
    return AvatarEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      imagePath: imagePath,
      gender: gender,
      age: age,
      pose: pose,
    );
  }
}
