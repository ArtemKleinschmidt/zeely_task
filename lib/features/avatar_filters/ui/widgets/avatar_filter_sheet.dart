import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_outlined_frame.dart';
import '../../domain/entities/avatar_filter_category.dart';
import '../localization/avatar_filters_localizations.dart';
import 'avatar_filter_options.dart';

final class AvatarFilterSheet extends StatefulWidget {
  const AvatarFilterSheet({
    required this.category,
    required this.options,
    required this.initialSelection,
    super.key,
  });

  final AvatarFilterCategory category;
  final List<AvatarFilterOption> options;
  final Set<Enum> initialSelection;

  @override
  State<AvatarFilterSheet> createState() => _AvatarFilterSheetState();
}

final class _AvatarFilterSheetState extends State<AvatarFilterSheet> {
  late final Set<Enum> _staged = {...widget.initialSelection};

  void _toggle(Enum value) {
    setState(() {
      if (!_staged.add(value)) _staged.remove(value);
    });
  }

  void _save() {
    Get.back<Set<Enum>>(result: Set<Enum>.from(_staged));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Get.back<void>(),
                child: const SizedBox.expand(),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16 + mediaQuery.viewInsets.bottom,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(28),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.category.localizedLabel,
                                    style: AppTextStyles.surfaceTitle,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Get.back<void>(),
                                  icon: SvgPicture.asset(
                                    AppIconAssets.close,
                                    width: 14,
                                    height: 14,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.textPrimary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...widget.options.map(
                            (option) => _OptionRow(
                              option: option,
                              selected: _staged.contains(option.value),
                              onTap: () => _toggle(option.value),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 62,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.textPrimary,
                                  foregroundColor: AppColors.textInverse,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                onPressed: _save,
                                child: Text(
                                  'avatar_filters.save'.tr,
                                  style: AppTextStyles.primaryButtonLabel
                                      .copyWith(color: AppColors.textInverse),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final AvatarFilterOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.label, style: AppTextStyles.emphasisLabel),
                      if (option.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(option.subtitle!, style: AppTextStyles.body),
                      ],
                    ],
                  ),
                ),
                _SquareCheckbox(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _SquareCheckbox extends StatelessWidget {
  const _SquareCheckbox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: AppOutlinedFrame(
        backgroundColor: selected ? AppColors.textPrimary : AppColors.surface,
        borderColor: selected ? AppColors.textPrimary : AppColors.border,
        borderRadius: BorderRadius.circular(5),
        borderWidth: 1,
        child: selected
            ? Center(
                child: SvgPicture.asset(
                  AppIconAssets.check,
                  width: 12,
                  height: 12,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
