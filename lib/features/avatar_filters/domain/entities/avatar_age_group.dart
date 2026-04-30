enum AvatarAgeGroup { youngAdults, adults, middleAged, older }

extension AvatarAgeGroupX on AvatarAgeGroup {
  int get minAge {
    switch (this) {
      case AvatarAgeGroup.youngAdults:
        return 18;
      case AvatarAgeGroup.adults:
        return 25;
      case AvatarAgeGroup.middleAged:
        return 40;
      case AvatarAgeGroup.older:
        return 65;
    }
  }

  int? get maxAge {
    switch (this) {
      case AvatarAgeGroup.youngAdults:
        return 24;
      case AvatarAgeGroup.adults:
        return 39;
      case AvatarAgeGroup.middleAged:
        return 64;
      case AvatarAgeGroup.older:
        return null;
    }
  }

  bool contains(int age) {
    final upper = maxAge;
    return age >= minAge && (upper == null || age <= upper);
  }
}
