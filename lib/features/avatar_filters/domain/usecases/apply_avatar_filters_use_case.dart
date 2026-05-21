import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';

import '../entities/avatar_filters_entity.dart';

final class ApplyAvatarFiltersUseCase {
  const ApplyAvatarFiltersUseCase();

  List<AvatarEntity> call({
    required List<AvatarEntity> avatars,
    required AvatarFiltersEntity filters,
  }) {
    if (!filters.hasActiveSelections) {
      return List<AvatarEntity>.unmodifiable(avatars);
    }

    return avatars
        .where((avatar) => _matches(avatar, filters))
        .toList(growable: false);
  }

  bool _matches(AvatarEntity avatar, AvatarFiltersEntity filters) {
    for (final entry in filters.selections.entries) {
      final values = entry.value;
      if (values.isEmpty) continue;
      if (!entry.key.matches(avatar, values)) return false;
    }
    return true;
  }
}
