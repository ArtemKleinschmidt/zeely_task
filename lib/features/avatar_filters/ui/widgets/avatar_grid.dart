import 'package:flutter/material.dart';

import '../../../../core/widgets/amazing_animated_grid.dart';
import '../../domain/entities/avatar_entity.dart';
import 'avatar_card.dart';

final class AvatarGrid extends StatelessWidget {
  const AvatarGrid({
    required this.avatars,
    required this.emptyState,
    super.key,
  });

  final List<AvatarEntity> avatars;
  final Widget emptyState;

  @override
  Widget build(BuildContext context) {
    return AmazingAnimatedGrid<AvatarEntity>(
      items: avatars,
      keyOf: (avatar) => avatar.id,
      itemBuilder: (context, avatar) => AvatarCard(avatar: avatar),
      crossAxisCount: 3,
      childAspectRatio: 0.74,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      emptyState: emptyState,
    );
  }
}
