import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

final class ExampleButton extends StatelessWidget {
  const ExampleButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            const Icon(
              Icons.play_arrow,
              color: AppColors.textInverse,
              size: 14,
            ),
            Text(
              'avatar_details.example'.tr,
              style: AppTextStyles.chipLabel.copyWith(
                color: AppColors.textInverse,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
