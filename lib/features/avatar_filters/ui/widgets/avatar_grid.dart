import 'package:flutter/material.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';

import '../../../../core/widgets/amazing_animated_grid.dart';
import 'avatar_card.dart';

final class AvatarGrid extends StatelessWidget {
  const AvatarGrid({
    required this.avatars,
    required this.emptyState,
    this.onAvatarTap,
    super.key,
  });

  final List<AvatarEntity> avatars;
  final Widget emptyState;
  final ValueChanged<AvatarEntity>? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return AmazingAnimatedGrid<AvatarEntity>(
      items: avatars,
      keyOf: (avatar) => avatar.id,
      itemBuilder: (context, avatar) => AvatarCard(
        avatar: avatar,
        onTap: onAvatarTap == null ? null : () => onAvatarTap!(avatar),
      ),
      crossAxisCount: 3,
      childAspectRatio: 0.74,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      emptyState: emptyState,
    );
  }
}
