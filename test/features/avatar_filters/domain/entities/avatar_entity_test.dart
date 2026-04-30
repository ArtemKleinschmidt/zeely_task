import 'package:flutter_test/flutter_test.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_pose.dart';

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
      );

      expect(avatar.fullName, 'Ethan Carter');
    });
  });
}
