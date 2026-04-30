import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_outlined_frame.dart';

final class AvatarFilterChip extends StatelessWidget {
  const AvatarFilterChip({
    required this.label,
    required this.count,
    required this.onTap,
    super.key,
  });

  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppOutlinedFrame(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.chipLabel),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: count > 0
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              ),
                          child: _CountBadge(
                            key: ValueKey(count),
                            count: count,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 6),
            SvgPicture.asset(
              AppIconAssets.arrowDown,
              width: 12,
              height: 12,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _CountBadge extends StatelessWidget {
  const _CountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: AppColors.textPrimary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.bottomCenter,
      child: Text(
        '$count',
        style: AppTextStyles.chipLabel.copyWith(
          color: AppColors.textInverse,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
