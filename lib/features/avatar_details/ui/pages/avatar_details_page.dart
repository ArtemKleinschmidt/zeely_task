import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../presentation/controllers/avatar_details_controller.dart';
import '../widgets/about_avatar_section.dart';
import '../widgets/avatar_details_top_bar.dart';
import '../widgets/avatar_flavor_chips.dart';
import '../widgets/avatar_photo_card.dart';
import '../widgets/select_avatar_button.dart';

final class AvatarDetailsPage extends GetView<AvatarDetailsController> {
  const AvatarDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final details = controller.details;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Obx(
                      () => AvatarDetailsTopBar(
                        onBack: () => Get.back<void>(),
                        onShare: controller.shareAvatar,
                        favoriteButton: FavoriteButton(
                          isFavorite: controller.isFavorite.value,
                          onTap: controller.toggleFavorite,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AvatarPhotoCard(
                      imagePath: details.imagePath,
                      name: details.name,
                      gender: details.gender,
                      age: details.age,
                      scoreLabel: details.scoreLabel,
                      onExamplePressed: controller.onExamplePressed,
                    ),
                    const SizedBox(height: 16),
                    AvatarFlavorChips(flavors: details.flavors),
                    const SizedBox(height: 24),
                    AboutAvatarSection(description: details.description),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SelectAvatarButton(onPressed: controller.onSelectAvatar),
            ),
          ],
        ),
      ),
    );
  }
}
