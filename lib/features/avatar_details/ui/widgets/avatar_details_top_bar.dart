import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

final class AvatarDetailsTopBar extends StatelessWidget {
  const AvatarDetailsTopBar({
    required this.onBack,
    required this.onShare,
    required this.favoriteButton,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onShare;
  final Widget favoriteButton;

  @override
  Widget build(BuildContext context) {
    final shareIcon = Theme.of(context).platform == TargetPlatform.iOS
        ? Icons.ios_share
        : Icons.share;

    return Row(
      children: [
        _CircleIconButton(icon: Icons.arrow_back, onTap: onBack),
        const Spacer(),
        _CircleIconButton(icon: shareIcon, onTap: onShare),
        const SizedBox(width: 8),
        favoriteButton,
      ],
    );
  }
}

final class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
      ),
    );
  }
}

final class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    required this.isFavorite,
    required this.onTap,
    super.key,
  });

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
