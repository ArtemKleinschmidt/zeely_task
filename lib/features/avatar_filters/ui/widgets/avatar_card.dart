import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/avatar_entity.dart';
import '../localization/avatar_filters_localizations.dart';

final class AvatarCard extends StatelessWidget {
  const AvatarCard({required this.avatar, super.key});

  final AvatarEntity avatar;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            avatar.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: AppColors.surfaceMuted,
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            },
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  avatar.firstName,
                  style: AppTextStyles.emphasisLabel.copyWith(
                    color: AppColors.textInverse,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${avatar.gender.localizedLabel} · ${avatar.ageLabel}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textInverse.withValues(alpha: 0.85),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
