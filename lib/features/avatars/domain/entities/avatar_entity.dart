import 'avatar_flavor.dart';
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
    required this.flavors,
    required this.score,
    required this.description,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String imagePath;
  final Gender gender;
  final int age;
  final Pose pose;
  final List<AvatarFlavor> flavors;
  final double score;
  final String description;

  String get fullName => '$firstName $lastName';

  String get ageLabel => age.toString();

  String get scoreLabel => score.toStringAsFixed(1);
}
