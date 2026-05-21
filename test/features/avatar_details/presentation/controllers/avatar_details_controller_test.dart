import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeely_task/features/avatar_details/domain/entities/avatar_details_entity.dart';
import 'package:zeely_task/features/avatar_details/domain/usecases/build_avatar_details_use_case.dart';
import 'package:zeely_task/features/avatar_details/presentation/controllers/avatar_details_controller.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_flavor.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_pose.dart';

final class MockBuildAvatarDetailsUseCase extends Mock
    implements BuildAvatarDetailsUseCase {}

const _stubAvatar = AvatarEntity(
  id: 'avatar_001',
  firstName: 'Ethan',
  lastName: 'Carter',
  imagePath: 'assets/images/avatar_001_male_45_standing.png',
  gender: Gender.male,
  age: 45,
  pose: Pose.standing,
  flavors: [AvatarFlavor.confident, AvatarFlavor.grounded],
  score: 4.8,
  description: 'A dependable presence.',
);

const _stubDetails = AvatarDetailsEntity(
  avatarId: 'avatar_001',
  name: 'Ethan Carter',
  imagePath: 'assets/images/avatar_001_male_45_standing.png',
  gender: Gender.male,
  age: 45,
  scoreLabel: '4.8',
  flavors: [AvatarFlavor.confident, AvatarFlavor.grounded],
  description: 'A dependable presence.',
);

void main() {
  late MockBuildAvatarDetailsUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockBuildAvatarDetailsUseCase();
    when(() => mockUseCase(_stubAvatar)).thenReturn(_stubDetails);
  });

  tearDown(() {
    Get.reset();
  });

  AvatarDetailsController buildController() => AvatarDetailsController(
    avatar: _stubAvatar,
    buildAvatarDetailsUseCase: mockUseCase,
  );

  group('AvatarDetailsController — initialization', () {
    test('builds details via use case during onInit', () {
      final controller = buildController();
      Get.put(controller);

      expect(controller.details, _stubDetails);
      verify(() => mockUseCase(_stubAvatar)).called(1);
    });

    test('isFavorite starts as false', () {
      final controller = buildController();
      Get.put(controller);

      expect(controller.isFavorite.value, isFalse);
    });
  });
}
