import 'package:flutter/material.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_flavor.dart';
import 'package:zeely_task/features/avatars/ui/localization/avatar_localizations.dart';

import 'flavor_chip.dart';

final class AvatarFlavorChips extends StatelessWidget {
  const AvatarFlavorChips({required this.flavors, super.key});

  final List<AvatarFlavor> flavors;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          for (var i = 0; i < flavors.length; i++)
            FlavorChip(label: flavors[i].localizedLabel, selected: i == 0),
        ],
      ),
    );
  }
}
