enum FoodType {
  veg,
  nonVeg,
  both;

  String get label => switch (this) {
        FoodType.veg => 'Veg',
        FoodType.nonVeg => 'Non-Veg',
        FoodType.both => 'Both',
      };
}

class Mess {
  const Mess({
    required this.messId,
    required this.messName,
    required this.description,
    required this.address,
    required this.averageRating,
    required this.totalRatings,
    required this.verified,
    required this.coverImageUrl,
    required this.galleryImages,
    required this.distanceKm,
    required this.foodType,
    required this.startingPrice,
  });

  final String messId;
  final String messName;
  final String description;
  final String address;
  final double averageRating;
  final int totalRatings;
  final bool verified;
  final String coverImageUrl;
  final List<String> galleryImages;
  final double distanceKm;
  final FoodType foodType;
  final int startingPrice;
}
