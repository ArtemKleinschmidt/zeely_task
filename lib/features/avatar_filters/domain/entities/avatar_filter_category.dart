import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_pose.dart';

import 'avatar_age_group.dart';

typedef AvatarFilterMatcher =
    bool Function(AvatarEntity avatar, Set<Enum> selectedValues);

enum AvatarFilterCategory {
  gender(_matchesGender),
  age(_matchesAge),
  pose(_matchesPose);

  const AvatarFilterCategory(this.matches);

  final AvatarFilterMatcher matches;
}

bool _matchesGender(AvatarEntity avatar, Set<Enum> values) =>
    values.whereType<Gender>().contains(avatar.gender);

bool _matchesPose(AvatarEntity avatar, Set<Enum> values) =>
    values.whereType<Pose>().contains(avatar.pose);

bool _matchesAge(AvatarEntity avatar, Set<Enum> values) {
  return values.whereType<AvatarAgeGroup>().any(
    (group) => group.contains(avatar.age),
  );
}
