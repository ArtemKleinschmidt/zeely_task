import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_pose.dart';
import 'package:zeely_task/features/avatars/ui/localization/avatar_localizations.dart';

import '../../domain/entities/avatar_age_group.dart';
import '../../domain/entities/avatar_filter_category.dart';
import '../localization/avatar_filters_localizations.dart';

final class AvatarFilterOption {
  const AvatarFilterOption({
    required this.value,
    required this.label,
    this.subtitle,
  });

  final Enum value;
  final String label;
  final String? subtitle;
}

abstract final class AvatarFilterOptions {
  static List<AvatarFilterOption> forCategory(AvatarFilterCategory category) {
    switch (category) {
      case AvatarFilterCategory.gender:
        return [
          AvatarFilterOption(
            value: Gender.male,
            label: Gender.male.localizedFilterLabel,
          ),
          AvatarFilterOption(
            value: Gender.female,
            label: Gender.female.localizedFilterLabel,
          ),
        ];
      case AvatarFilterCategory.age:
        return AvatarAgeGroup.values
            .map(
              (group) => AvatarFilterOption(
                value: group,
                label: group.localizedLabel,
                subtitle: group.localizedRangeLabel,
              ),
            )
            .toList(growable: false);
      case AvatarFilterCategory.pose:
        return Pose.values
            .map(
              (pose) =>
                  AvatarFilterOption(value: pose, label: pose.localizedLabel),
            )
            .toList(growable: false);
    }
  }
}
