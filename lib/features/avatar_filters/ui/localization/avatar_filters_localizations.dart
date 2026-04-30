import 'package:get/get.dart';

import '../../domain/entities/avatar_age_group.dart';
import '../../domain/entities/avatar_filter_category.dart';
import '../../domain/entities/avatar_gender.dart';
import '../../domain/entities/avatar_pose.dart';

extension AvatarFilterCategoryLocalization on AvatarFilterCategory {
  String get localizedLabel {
    return switch (this) {
      AvatarFilterCategory.gender => 'avatar_filters.category.gender'.tr,
      AvatarFilterCategory.age => 'avatar_filters.category.age'.tr,
      AvatarFilterCategory.pose => 'avatar_filters.category.pose'.tr,
    };
  }
}

extension AvatarAgeGroupLocalization on AvatarAgeGroup {
  String get localizedLabel {
    return switch (this) {
      AvatarAgeGroup.youngAdults => 'avatar_filters.age_group.young_adults'.tr,
      AvatarAgeGroup.adults => 'avatar_filters.age_group.adults'.tr,
      AvatarAgeGroup.middleAged =>
        'avatar_filters.age_group.middle_aged_adults'.tr,
      AvatarAgeGroup.older => 'avatar_filters.age_group.older_adults'.tr,
    };
  }

  String get localizedRangeLabel {
    return switch (this) {
      AvatarAgeGroup.youngAdults => 'avatar_filters.age_range.young_adults'.tr,
      AvatarAgeGroup.adults => 'avatar_filters.age_range.adults'.tr,
      AvatarAgeGroup.middleAged =>
        'avatar_filters.age_range.middle_aged_adults'.tr,
      AvatarAgeGroup.older => 'avatar_filters.age_range.older_adults'.tr,
    };
  }
}

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
