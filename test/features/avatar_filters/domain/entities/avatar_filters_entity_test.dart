import 'package:flutter_test/flutter_test.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_age_group.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_filter_category.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_filters_entity.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_pose.dart';

void main() {
  group('AvatarFiltersEntity', () {
    test('deep-copies incoming selections into immutable sets', () {
      final genders = {Gender.male};
      final selections = <AvatarFilterCategory, Iterable<Enum>>{
        AvatarFilterCategory.gender: genders,
      };
      final filters = AvatarFiltersEntity(selections: selections);

      genders.add(Gender.female);
      selections[AvatarFilterCategory.pose] = {Pose.selfie};

      expect(filters.valuesFor(AvatarFilterCategory.gender), {Gender.male});
      expect(filters.valuesFor(AvatarFilterCategory.pose), isEmpty);
      expect(
        () => filters.selections[AvatarFilterCategory.age] = {
          AvatarAgeGroup.older,
        },
        throwsUnsupportedError,
      );
      expect(
        () => filters.valuesFor(AvatarFilterCategory.gender).add(Gender.female),
        throwsUnsupportedError,
      );
    });

    test('replaces category selections without mutating existing filters', () {
      final filters = AvatarFiltersEntity(
        selections: {
          AvatarFilterCategory.gender: {Gender.male},
          AvatarFilterCategory.age: {AvatarAgeGroup.adults},
        },
      );

      final next = filters.copyWithSelection(AvatarFilterCategory.pose, {
        Pose.selfie,
      });

      expect(filters.valuesFor(AvatarFilterCategory.pose), isEmpty);
      expect(next.valuesFor(AvatarFilterCategory.gender), {Gender.male});
      expect(next.valuesFor(AvatarFilterCategory.age), {AvatarAgeGroup.adults});
      expect(next.valuesFor(AvatarFilterCategory.pose), {Pose.selfie});
    });

    test('removes empty category selections', () {
      final filters = AvatarFiltersEntity(
        selections: {
          AvatarFilterCategory.gender: {Gender.male},
        },
      );

      final next = filters.copyWithSelection(AvatarFilterCategory.gender, {});

      expect(next.hasActiveSelections, isFalse);
      expect(next.selections, isEmpty);
    });
  });
}
