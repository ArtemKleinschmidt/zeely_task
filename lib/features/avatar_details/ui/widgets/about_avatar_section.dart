import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

final class AboutAvatarSection extends StatelessWidget {
  const AboutAvatarSection({required this.description, super.key});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'avatar_details.about_avatar'.tr.toUpperCase(),
          style: AppTextStyles.eyebrow.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Text(description, style: AppTextStyles.body),
      ],
    );
  }
}
