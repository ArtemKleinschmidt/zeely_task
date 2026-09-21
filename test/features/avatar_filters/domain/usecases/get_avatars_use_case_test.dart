import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_pose.dart';
import 'package:zeely_task/features/avatars/domain/repositories/avatar_repository.dart';
import 'package:zeely_task/features/avatars/domain/usecases/get_avatars_use_case.dart';

final class MockAvatarRepository extends Mock implements AvatarRepository {}

const _stubAvatar = AvatarEntity(
  id: '1',
  firstName: 'Test',
  lastName: 'Avatar',
  imagePath: 'assets/images/avatar_001_male_45_standing.png',
  gender: Gender.male,
  age: 30,
  pose: Pose.standing,
  flavors: [],
  score: 4.5,
  description: 'A test avatar.',
);

void main() {
  late MockAvatarRepository mockRepository;
  late GetAvatarsUseCaseImpl useCase;

  setUp(() {
    mockRepository = MockAvatarRepository();
    useCase = GetAvatarsUseCaseImpl(mockRepository);
  });

  group('GetAvatarsUseCase', () {
    test('returns the list of avatars provided by the repository', () async {
      when(
        () => mockRepository.getAvatars(),
      ).thenAnswer((_) async => [_stubAvatar]);

      final result = await useCase();

      expect(result, [_stubAvatar]);
    });

    test(
      'returns an empty list when the repository returns no avatars',
      () async {
        when(() => mockRepository.getAvatars()).thenAnswer((_) async => []);

        final result = await useCase();

        expect(result, isEmpty);
      },
    );

    test('delegates to the repository exactly once per call', () async {
      when(() => mockRepository.getAvatars()).thenAnswer((_) async => []);

      await useCase();

      verify(() => mockRepository.getAvatars()).called(1);
    });

    test('propagates exceptions thrown by the repository', () async {
      when(
        () => mockRepository.getAvatars(),
      ).thenThrow(Exception('network error'));

      expect(() => useCase(), throwsException);
    });
  });
}
