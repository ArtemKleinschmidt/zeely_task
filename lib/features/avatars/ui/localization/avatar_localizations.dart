import 'package:get/get.dart';

import '../../domain/entities/avatar_flavor.dart';
import '../../domain/entities/avatar_gender.dart';
import '../../domain/entities/avatar_pose.dart';

extension GenderLocalization on Gender {
  String get localizedLabel {
    return switch (this) {
      Gender.male => 'avatar_filters.gender.male'.tr,
      Gender.female => 'avatar_filters.gender.female'.tr,
    };
  }

  String get localizedFilterLabel {
    return switch (this) {
      Gender.male => 'avatar_filters.gender_filter.men'.tr,
      Gender.female => 'avatar_filters.gender_filter.women'.tr,
    };
  }
}

extension PoseLocalization on Pose {
  String get localizedLabel {
    return switch (this) {
      Pose.standing => 'avatar_filters.pose.standing'.tr,
      Pose.sitting => 'avatar_filters.pose.sitting'.tr,
      Pose.selfie => 'avatar_filters.pose.selfie'.tr,
      Pose.carSelfie => 'avatar_filters.pose.car_selfie'.tr,
      Pose.walking => 'avatar_filters.pose.walking'.tr,
    };
  }
}

extension AvatarFlavorLocalization on AvatarFlavor {
  String get localizedLabel {
    return switch (this) {
      AvatarFlavor.warm => 'avatars.flavor.warm'.tr,
      AvatarFlavor.natural => 'avatars.flavor.natural'.tr,
      AvatarFlavor.confident => 'avatars.flavor.confident'.tr,
      AvatarFlavor.empathetic => 'avatars.flavor.empathetic'.tr,
      AvatarFlavor.playful => 'avatars.flavor.playful'.tr,
      AvatarFlavor.grounded => 'avatars.flavor.grounded'.tr,
    };
  }
}
