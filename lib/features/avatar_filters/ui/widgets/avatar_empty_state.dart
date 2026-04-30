import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

final class AvatarEmptyState extends StatelessWidget {
  const AvatarEmptyState({
    required this.title,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_drink_outlined,
              size: 96,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.sectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                ),
                child: Text(actionLabel, style: AppTextStyles.emphasisLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
