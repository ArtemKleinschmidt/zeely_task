import 'package:flutter_test/flutter_test.dart';
import 'package:zeely_task/features/avatar_details/domain/usecases/build_avatar_details_use_case.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_flavor.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_pose.dart';

const _stubAvatar = AvatarEntity(
  id: 'avatar_042',
  firstName: 'Olivia',
  lastName: 'Bennett',
  imagePath: 'assets/images/avatar_002_female_28_standing.png',
  gender: Gender.female,
  age: 28,
  pose: Pose.standing,
  flavors: [AvatarFlavor.warm, AvatarFlavor.confident],
  score: 4.9,
  description: 'A warm and confident presence.',
);

void main() {
  late BuildAvatarDetailsUseCaseImpl useCase;

  setUp(() {
    useCase = const BuildAvatarDetailsUseCaseImpl();
  });

  group('BuildAvatarDetailsUseCase', () {
    test('maps avatarId from avatar id', () {
      final result = useCase(_stubAvatar);
      expect(result.avatarId, 'avatar_042');
    });

    test('maps name as fullName (firstName + lastName)', () {
      final result = useCase(_stubAvatar);
      expect(result.name, 'Olivia Bennett');
    });

    test('maps imagePath unchanged', () {
      final result = useCase(_stubAvatar);
      expect(result.imagePath, _stubAvatar.imagePath);
    });

    test('maps gender unchanged', () {
      final result = useCase(_stubAvatar);
      expect(result.gender, Gender.female);
    });

    test('maps age unchanged', () {
      final result = useCase(_stubAvatar);
      expect(result.age, 28);
    });

    test('maps scoreLabel as formatted string', () {
      final result = useCase(_stubAvatar);
      expect(result.scoreLabel, '4.9');
    });

    test('maps flavors list unchanged', () {
      final result = useCase(_stubAvatar);
      expect(result.flavors, [AvatarFlavor.warm, AvatarFlavor.confident]);
    });

    test('maps description unchanged', () {
      final result = useCase(_stubAvatar);
      expect(result.description, 'A warm and confident presence.');
    });

    test('scoreLabel formats to one decimal place for whole number scores', () {
      const avatar = AvatarEntity(
        id: 'a',
        firstName: 'Test',
        lastName: 'Avatar',
        imagePath: 'path',
        gender: Gender.male,
        age: 30,
        pose: Pose.standing,
        flavors: [],
        score: 4.0,
        description: 'desc',
      );

      final result = useCase(avatar);
      expect(result.scoreLabel, '4.0');
    });
  });
}
