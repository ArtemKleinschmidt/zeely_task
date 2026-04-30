import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_outlined_frame.dart';
import '../../domain/entities/avatar_filter_category.dart';
import '../../presentation/controllers/avatar_filters_controller.dart';
import '../../presentation/controllers/avatars_load_state.dart';
import '../localization/avatar_filters_localizations.dart';
import '../widgets/avatar_empty_state.dart';
import '../widgets/avatar_filter_chip.dart';
import '../widgets/avatar_filter_options.dart';
import '../widgets/avatar_filter_sheet.dart';
import '../widgets/avatar_grid.dart';

final class AvatarFiltersPage extends GetView<AvatarFiltersController> {
  const AvatarFiltersPage({super.key});

  Future<void> _openSheet(AvatarFilterCategory category) async {
    final result = await Get.bottomSheet<Set<Enum>>(
      AvatarFilterSheet(
        category: category,
        options: AvatarFilterOptions.forCategory(category),
        initialSelection: controller.activeFilters.value.valuesFor(category),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.52),
      elevation: 0,
    );

    if (result != null) {
      controller.replaceSelection(category, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => SystemNavigator.pop(),
          icon: SvgPicture.asset(
            AppIconAssets.arrowBack,
            width: 9,
            height: 14,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Text(
              'avatar_filters.all_avatars'.tr,
              style: AppTextStyles.surfaceTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Obx(
              () => _FilterRow(
                hasActiveFilters: controller.hasActiveFilters,
                onReset: controller.resetFilters,
                countFor: controller.selectionCountFor,
                onCategoryTap: _openSheet,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return switch (controller.loadState.value) {
                AvatarsLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                AvatarsLoadFailed() => AvatarEmptyState(
                  title: 'avatar_filters.error.title'.tr,
                  actionLabel: 'avatar_filters.error.retry'.tr,
                  onPressed: () => controller.loadAvatars(),
                ),
                AvatarsLoaded() => AvatarGrid(
                  avatars: controller.filteredAvatars,
                  emptyState: AvatarEmptyState(
                    title: controller.hasActiveFilters
                        ? 'avatar_filters.empty.filtered_title'.tr
                        : 'avatar_filters.empty.default_title'.tr,
                    actionLabel: controller.hasActiveFilters
                        ? 'avatar_filters.empty.clear_filters'.tr
                        : 'avatar_filters.empty.reload_avatars'.tr,
                    onPressed: controller.hasActiveFilters
                        ? controller.resetFilters
                        : () => controller.loadAvatars(),
                  ),
                ),
              };
            }),
          ),
        ],
      ),
    );
  }
}

final class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.hasActiveFilters,
    required this.onReset,
    required this.countFor,
    required this.onCategoryTap,
  });

  final bool hasActiveFilters;
  final VoidCallback onReset;
  final int Function(AvatarFilterCategory category) countFor;
  final ValueChanged<AvatarFilterCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    const chipSpacing = 8.0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.centerLeft,
            child: hasActiveFilters
                ? Padding(
                    padding: const EdgeInsets.only(right: chipSpacing),
                    child: _ResetChip(onTap: onReset),
                  )
                : const SizedBox.shrink(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: chipSpacing,
            children: [
              for (final category in AvatarFilterCategory.values)
                AvatarFilterChip(
                  label: category.localizedLabel,
                  count: countFor(category),
                  onTap: () => onCategoryTap(category),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _ResetChip extends StatelessWidget {
  const _ResetChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppOutlinedFrame(
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Center(
          child: SvgPicture.asset(
            AppIconAssets.close,
            width: 10,
            height: 10,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
