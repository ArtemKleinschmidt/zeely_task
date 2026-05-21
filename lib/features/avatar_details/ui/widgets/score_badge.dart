import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

final class ScoreBadge extends StatelessWidget {
  const ScoreBadge({required this.scoreLabel, super.key});

  final String scoreLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          const Icon(Icons.star, color: AppColors.warning, size: 14),
          Text(
            scoreLabel,
            style: AppTextStyles.chipLabel.copyWith(
              color: AppColors.textInverse,
            ),
          ),
        ],
      ),
    );
  }
}
