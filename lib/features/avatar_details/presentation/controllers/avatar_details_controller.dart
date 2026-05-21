import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';

import '../../domain/entities/avatar_details_entity.dart';
import '../../domain/usecases/build_avatar_details_use_case.dart';

final class AvatarDetailsController extends GetxController {
  AvatarDetailsController({
    required this.avatar,
    required this.buildAvatarDetailsUseCase,
  });

  final AvatarEntity avatar;
  final BuildAvatarDetailsUseCase buildAvatarDetailsUseCase;

  late final AvatarDetailsEntity details;
  final RxBool isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    details = buildAvatarDetailsUseCase(avatar);
  }

  void toggleFavorite() {
    isFavorite.toggle();
    _showToast(
      isFavorite.value
          ? 'avatar_details.favorite_added'.tr
          : 'avatar_details.favorite_removed'.tr,
      duration: const Duration(seconds: 1),
    );
  }

  Future<void> shareAvatar() async {
    try {
      await Share.share('${details.name}\n${'avatar_details.share_text'.tr}');
    } catch (_) {}
  }

  void onExamplePressed() {
    _showToast('avatar_details.example_tapped'.tr);
  }

  void onSelectAvatar() {
    _showToast('avatar_details.selected'.tr);
    Get.back<void>();
  }

  void _showToast(String message, {Duration duration = const Duration(seconds: 2)}) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      borderRadius: 12,
      duration: duration,
      margin: const EdgeInsets.fromLTRB(48, 0, 48, 32),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }
}
