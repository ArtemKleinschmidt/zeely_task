import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

final class FlavorChip extends StatelessWidget {
  const FlavorChip({required this.label, required this.selected, super.key});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.textPrimary : AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: selected ? AppColors.textPrimary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.chipLabel.copyWith(
          color: selected ? AppColors.textInverse : AppColors.textPrimary,
        ),
      ),
    );
  }
}
