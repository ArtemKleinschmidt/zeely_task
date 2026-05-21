import 'package:get/get.dart';

import '../../domain/entities/avatar_age_group.dart';
import '../../domain/entities/avatar_filter_category.dart';

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
