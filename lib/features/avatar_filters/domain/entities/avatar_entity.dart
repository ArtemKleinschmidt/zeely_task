import 'avatar_gender.dart';
import 'avatar_pose.dart';

final class AvatarEntity {
  const AvatarEntity({
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

  String get ageLabel => age.toString();
}
