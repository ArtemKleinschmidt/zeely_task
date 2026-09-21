import 'package:flutter/material.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/ui/localization/avatar_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'example_button.dart';
import 'score_badge.dart';

final class AvatarPhotoCard extends StatelessWidget {
  const AvatarPhotoCard({
    required this.imagePath,
    required this.name,
    required this.gender,
    required this.age,
    required this.scoreLabel,
    required this.onExamplePressed,
    super.key,
  });

  final String imagePath;
  final String name;
  final Gender gender;
  final int age;
  final String scoreLabel;
  final VoidCallback onExamplePressed;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.75,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(
                  color: AppColors.surfaceMuted,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.textSecondary,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.4, 1.0],
                    colors: [Colors.transparent, Color(0xDD000000)],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: ExampleButton(onPressed: onExamplePressed),
            ),
            Positioned(
              left: 16,
              right: 80,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.heroTitle.copyWith(
                      color: AppColors.textInverse,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${gender.localizedLabel} · $age',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textInverse.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: ScoreBadge(scoreLabel: scoreLabel),
            ),
          ],
        ),
      ),
    );
  }
}
