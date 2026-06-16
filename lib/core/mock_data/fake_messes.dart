import '../../models/mess_model.dart';

const _placeholderImage =
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800';

final fakeMesses = <Mess>[
  const Mess(
    messId: 'mess_001',
    messName: 'Sai Mess',
    description:
        'Home-style Maharashtrian meals with fresh roti, dal, and seasonal sabzi.',
    address: 'Cidco, Chhatrapati Sambhajinagar',
    averageRating: 4.5,
    totalRatings: 128,
    verified: true,
    coverImageUrl: _placeholderImage,
    galleryImages: [
      _placeholderImage,
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
    ],
    distanceKm: 0.8,
    foodType: FoodType.veg,
    startingPrice: 2500,
  ),
  const Mess(
    messId: 'mess_002',
    messName: 'Annapurna Mess',
    description:
        'Affordable daily meals popular with college students near Aurangabad University.',
    address: 'University Road, Chhatrapati Sambhajinagar',
    averageRating: 4.2,
    totalRatings: 94,
    verified: true,
    coverImageUrl:
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
    galleryImages: [
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
    ],
    distanceKm: 1.2,
    foodType: FoodType.both,
    startingPrice: 2200,
  ),
  const Mess(
    messId: 'mess_003',
    messName: 'Shree Tiffin Centre',
    description:
        'North Indian thali with generous portions and weekly menu rotation.',
    address: 'Jalna Road, Chhatrapati Sambhajinagar',
    averageRating: 4.0,
    totalRatings: 67,
    verified: false,
    coverImageUrl:
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
    galleryImages: [
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
      _placeholderImage,
    ],
    distanceKm: 2.1,
    foodType: FoodType.veg,
    startingPrice: 2800,
  ),
  const Mess(
    messId: 'mess_004',
    messName: 'Royal Biryani Mess',
    description:
        'Specialty non-veg meals with biryani on weekends and flexible dinner plans.',
    address: 'N-2 Cidco, Chhatrapati Sambhajinagar',
    averageRating: 4.7,
    totalRatings: 203,
    verified: true,
    coverImageUrl:
        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
    galleryImages: [
      'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
      'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800',
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
    ],
    distanceKm: 1.5,
    foodType: FoodType.nonVeg,
    startingPrice: 3500,
  ),
  const Mess(
    messId: 'mess_005',
    messName: 'Green Leaf Mess',
    description:
        'Pure vegetarian mess with organic vegetables and no onion-garlic options.',
    address: 'Paithan Gate, Chhatrapati Sambhajinagar',
    averageRating: 4.3,
    totalRatings: 51,
    verified: false,
    coverImageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    galleryImages: [
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
      _placeholderImage,
    ],
    distanceKm: 3.0,
    foodType: FoodType.veg,
    startingPrice: 2400,
  ),
];
