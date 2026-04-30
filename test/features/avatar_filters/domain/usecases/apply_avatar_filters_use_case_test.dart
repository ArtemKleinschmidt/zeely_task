import 'package:flutter_test/flutter_test.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_age_group.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_filter_category.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_filters_entity.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_pose.dart';
import 'package:zeely_task/features/avatar_filters/domain/usecases/apply_avatar_filters_use_case.dart';

AvatarEntity _avatar({
  String id = 'a',
  Gender gender = Gender.male,
  int age = 30,
  Pose pose = Pose.standing,
}) => AvatarEntity(
  id: id,
  firstName: 'Avatar',
  lastName: id,
  imagePath: 'assets/images/avatar_001_male_45_standing.png',
  gender: gender,
  age: age,
  pose: pose,
);

AvatarFiltersEntity _filters({
  Set<Gender> genders = const <Gender>{},
  Set<AvatarAgeGroup> ageGroups = const <AvatarAgeGroup>{},
  Set<Pose> poses = const <Pose>{},
}) => AvatarFiltersEntity(
  selections: {
    if (genders.isNotEmpty) AvatarFilterCategory.gender: genders,
    if (ageGroups.isNotEmpty) AvatarFilterCategory.age: ageGroups,
    if (poses.isNotEmpty) AvatarFilterCategory.pose: poses,
  },
);

void main() {
  late ApplyAvatarFiltersUseCase useCase;

  setUp(() {
    useCase = const ApplyAvatarFiltersUseCase();
  });

  group('ApplyAvatarFiltersUseCase — no active filters', () {
    test('returns all avatars unchanged when filters are empty', () {
      final avatars = [
        _avatar(id: '1'),
        _avatar(id: '2', gender: Gender.female),
      ];

      final result = useCase(
        avatars: avatars,
        filters: const AvatarFiltersEntity.empty(),
      );

      expect(result, equals(avatars));
    });

    test('returns empty list when input is empty and filters are empty', () {
      final result = useCase(
        avatars: [],
        filters: const AvatarFiltersEntity.empty(),
      );

      expect(result, isEmpty);
    });
  });

  group('ApplyAvatarFiltersUseCase — gender filter', () {
    test('returns only male avatars when gender filter is set to male', () {
      final male = _avatar(id: 'm', gender: Gender.male);
      final female = _avatar(id: 'f', gender: Gender.female);

      final result = useCase(
        avatars: [male, female],
        filters: _filters(genders: {Gender.male}),
      );

      expect(result, [male]);
    });

    test('returns only female avatars when gender filter is set to female', () {
      final male = _avatar(id: 'm', gender: Gender.male);
      final female = _avatar(id: 'f', gender: Gender.female);

      final result = useCase(
        avatars: [male, female],
        filters: _filters(genders: {Gender.female}),
      );

      expect(result, [female]);
    });

    test(
      'returns both genders when gender filter includes male and female',
      () {
        final male = _avatar(id: 'm', gender: Gender.male);
        final female = _avatar(id: 'f', gender: Gender.female);

        final result = useCase(
          avatars: [male, female],
          filters: _filters(genders: {Gender.male, Gender.female}),
        );

        expect(result, containsAll([male, female]));
      },
    );

    test('returns empty when no avatar matches the gender filter', () {
      final male = _avatar(id: 'm', gender: Gender.male);

      final result = useCase(
        avatars: [male],
        filters: _filters(genders: {Gender.female}),
      );

      expect(result, isEmpty);
    });
  });

  group('ApplyAvatarFiltersUseCase — pose filter', () {
    test('returns only standing avatars when pose filter is standing', () {
      final standing = _avatar(id: 's', pose: Pose.standing);
      final sitting = _avatar(id: 'sit', pose: Pose.sitting);

      final result = useCase(
        avatars: [standing, sitting],
        filters: _filters(poses: {Pose.standing}),
      );

      expect(result, [standing]);
    });

    test('returns avatars matching any of the selected poses', () {
      final standing = _avatar(id: 's', pose: Pose.standing);
      final selfie = _avatar(id: 'sel', pose: Pose.selfie);
      final sitting = _avatar(id: 'sit', pose: Pose.sitting);

      final result = useCase(
        avatars: [standing, selfie, sitting],
        filters: _filters(poses: {Pose.standing, Pose.selfie}),
      );

      expect(result, containsAll([standing, selfie]));
      expect(result, isNot(contains(sitting)));
    });

    test('returns empty when no avatar matches the pose filter', () {
      final standing = _avatar(id: 's', pose: Pose.standing);

      final result = useCase(
        avatars: [standing],
        filters: _filters(poses: {Pose.sitting}),
      );

      expect(result, isEmpty);
    });
  });

  group('ApplyAvatarFiltersUseCase — age filter', () {
    test('returns avatars in youngAdults range (18–24)', () {
      final young = _avatar(id: 'y', age: 22);
      final adult = _avatar(id: 'a', age: 30);

      final result = useCase(
        avatars: [young, adult],
        filters: _filters(ageGroups: {AvatarAgeGroup.youngAdults}),
      );

      expect(result, [young]);
    });

    test('returns avatars in adults range (25–39)', () {
      final young = _avatar(id: 'y', age: 22);
      final adult = _avatar(id: 'a', age: 30);

      final result = useCase(
        avatars: [young, adult],
        filters: _filters(ageGroups: {AvatarAgeGroup.adults}),
      );

      expect(result, [adult]);
    });

    test('returns avatars in middleAged range (40–64)', () {
      final middle = _avatar(id: 'm', age: 50);
      final young = _avatar(id: 'y', age: 22);

      final result = useCase(
        avatars: [middle, young],
        filters: _filters(ageGroups: {AvatarAgeGroup.middleAged}),
      );

      expect(result, [middle]);
    });

    test('returns avatars in older range (65+)', () {
      final older = _avatar(id: 'o', age: 70);
      final adult = _avatar(id: 'a', age: 30);

      final result = useCase(
        avatars: [older, adult],
        filters: _filters(ageGroups: {AvatarAgeGroup.older}),
      );

      expect(result, [older]);
    });

    test('includes boundary age values within the correct group', () {
      final minYoung = _avatar(id: 'min', age: 18);
      final maxYoung = _avatar(id: 'max', age: 24);

      final result = useCase(
        avatars: [minYoung, maxYoung],
        filters: _filters(ageGroups: {AvatarAgeGroup.youngAdults}),
      );

      expect(result, containsAll([minYoung, maxYoung]));
    });

    test('excludes boundary age that belongs to the next group', () {
      final firstAdult = _avatar(id: 'a', age: 25);

      final result = useCase(
        avatars: [firstAdult],
        filters: _filters(ageGroups: {AvatarAgeGroup.youngAdults}),
      );

      expect(result, isEmpty);
    });

    test('returns avatars spanning multiple selected age groups', () {
      final young = _avatar(id: 'y', age: 20);
      final older = _avatar(id: 'o', age: 70);
      final middle = _avatar(id: 'm', age: 50);

      final result = useCase(
        avatars: [young, older, middle],
        filters: _filters(
          ageGroups: {AvatarAgeGroup.youngAdults, AvatarAgeGroup.older},
        ),
      );

      expect(result, containsAll([young, older]));
      expect(result, isNot(contains(middle)));
    });
  });

  group('ApplyAvatarFiltersUseCase — combined filters', () {
    test('applies gender and pose filters together', () {
      final maleSitting = _avatar(
        id: 'ms',
        gender: Gender.male,
        pose: Pose.sitting,
      );
      final femaleStanding = _avatar(
        id: 'fs',
        gender: Gender.female,
        pose: Pose.standing,
      );
      final maleStanding = _avatar(
        id: 'mst',
        gender: Gender.male,
        pose: Pose.standing,
      );

      final result = useCase(
        avatars: [maleSitting, femaleStanding, maleStanding],
        filters: _filters(genders: {Gender.male}, poses: {Pose.standing}),
      );

      expect(result, [maleStanding]);
    });

    test('applies gender and age filters together', () {
      final youngMale = _avatar(id: 'ym', gender: Gender.male, age: 20);
      final youngFemale = _avatar(id: 'yf', gender: Gender.female, age: 20);
      final adultMale = _avatar(id: 'am', gender: Gender.male, age: 30);

      final result = useCase(
        avatars: [youngMale, youngFemale, adultMale],
        filters: _filters(
          genders: {Gender.male},
          ageGroups: {AvatarAgeGroup.youngAdults},
        ),
      );

      expect(result, [youngMale]);
    });

    test('returns empty when combined filters match no avatars', () {
      final maleSitting = _avatar(
        id: 'ms',
        gender: Gender.male,
        pose: Pose.sitting,
      );

      final result = useCase(
        avatars: [maleSitting],
        filters: _filters(genders: {Gender.female}, poses: {Pose.sitting}),
      );

      expect(result, isEmpty);
    });
  });
}
