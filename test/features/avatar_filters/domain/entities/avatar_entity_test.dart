import 'package:flutter_test/flutter_test.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_flavor.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_pose.dart';

void main() {
  group('AvatarEntity', () {
    test('builds fullName from firstName and lastName', () {
      const avatar = AvatarEntity(
        id: 'avatar_001',
        firstName: 'Ethan',
        lastName: 'Carter',
        imagePath: 'assets/images/avatar_001_male_45_standing.png',
        gender: Gender.male,
        age: 45,
        pose: Pose.standing,
        flavors: [AvatarFlavor.confident, AvatarFlavor.grounded],
        score: 4.8,
        description: 'A dependable and authoritative presence.',
      );

      expect(avatar.fullName, 'Ethan Carter');
    });

    test('scoreLabel formats to one decimal place', () {
      const avatar = AvatarEntity(
        id: 'avatar_001',
        firstName: 'Ethan',
        lastName: 'Carter',
        imagePath: 'assets/images/avatar_001_male_45_standing.png',
        gender: Gender.male,
        age: 45,
        pose: Pose.standing,
        flavors: [AvatarFlavor.confident],
        score: 4.8,
        description: 'Test.',
      );

      expect(avatar.scoreLabel, '4.8');
    });

    test('ageLabel returns the age as string', () {
      const avatar = AvatarEntity(
        id: 'avatar_001',
        firstName: 'Ethan',
        lastName: 'Carter',
        imagePath: 'assets/images/avatar_001_male_45_standing.png',
        gender: Gender.male,
        age: 45,
        pose: Pose.standing,
        flavors: [],
        score: 4.5,
        description: 'Test.',
      );

      expect(avatar.ageLabel, '45');
    });
  });
}
