import 'package:get/get.dart';

import '../../domain/entities/avatar_entity.dart';
import '../../domain/entities/avatar_filter_category.dart';
import '../../domain/entities/avatar_filters_entity.dart';
import '../../domain/usecases/apply_avatar_filters_use_case.dart';
import '../../domain/usecases/get_avatars_use_case.dart';
import 'avatars_load_state.dart';

final class AvatarFiltersController extends GetxController {
  AvatarFiltersController({
    required this.getAvatarsUseCase,
    required this.applyAvatarFiltersUseCase,
  });

  final GetAvatarsUseCase getAvatarsUseCase;
  final ApplyAvatarFiltersUseCase applyAvatarFiltersUseCase;

  final Rx<AvatarsLoadState> loadState = Rx<AvatarsLoadState>(
    const AvatarsLoading(),
  );
  final activeFilters = const AvatarFiltersEntity.empty().obs;

  @override
  void onInit() {
    super.onInit();
    loadAvatars();
  }

  bool get hasActiveFilters => activeFilters.value.hasActiveSelections;

  int selectionCountFor(AvatarFilterCategory category) {
    return activeFilters.value.selectionCountFor(category);
  }

  List<AvatarEntity> get filteredAvatars {
    final state = loadState.value;
    if (state is! AvatarsLoaded) return const [];
    return applyAvatarFiltersUseCase(
      avatars: state.avatars,
      filters: activeFilters.value,
    );
  }

  Future<void> loadAvatars() async {
    loadState.value = const AvatarsLoading();
    try {
      final loadedAvatars = await getAvatarsUseCase();
      loadState.value = AvatarsLoaded(loadedAvatars);
    } catch (error) {
      loadState.value = AvatarsLoadFailed(error);
    }
  }

  void applyFilters(AvatarFiltersEntity filters) {
    activeFilters.value = filters;
  }

  void replaceSelection(AvatarFilterCategory category, Set<Enum> values) {
    applyFilters(activeFilters.value.copyWithSelection(category, values));
  }

  void resetFilters() {
    applyFilters(const AvatarFiltersEntity.empty());
  }
}
