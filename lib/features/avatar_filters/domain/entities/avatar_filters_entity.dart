import 'avatar_filter_category.dart';

final class AvatarFiltersEntity {
  AvatarFiltersEntity({
    Map<AvatarFilterCategory, Iterable<Enum>> selections = const {},
  }) : selections = Map<AvatarFilterCategory, Set<Enum>>.unmodifiable(
         selections.map(
           (category, values) =>
               MapEntry(category, Set<Enum>.unmodifiable(values)),
         ),
       );

  const AvatarFiltersEntity.empty() : selections = const {};

  final Map<AvatarFilterCategory, Set<Enum>> selections;

  bool get hasActiveSelections {
    return selections.values.any((values) => values.isNotEmpty);
  }

  int selectionCountFor(AvatarFilterCategory category) {
    return valuesFor(category).length;
  }

  Set<Enum> valuesFor(AvatarFilterCategory category) {
    return selections[category] ?? const <Enum>{};
  }

  AvatarFiltersEntity copyWithSelection(
    AvatarFilterCategory category,
    Set<Enum> values,
  ) {
    final nextSelections = Map<AvatarFilterCategory, Set<Enum>>.from(
      selections,
    );

    if (values.isEmpty) {
      nextSelections.remove(category);
    } else {
      nextSelections[category] = Set<Enum>.unmodifiable(values);
    }

    return AvatarFiltersEntity(selections: nextSelections);
  }

  AvatarFiltersEntity clear() {
    return const AvatarFiltersEntity.empty();
  }
}
