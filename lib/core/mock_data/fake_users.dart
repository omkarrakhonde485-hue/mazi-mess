import '../../models/app_user.dart';

const _profilePhotoUrl =
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400';

final fakeCurrentUser = AppUser(
  userId: 'user_001',
  fullName: 'Omkar Rakhonde',
  phoneNumber: '9876543210',
  email: 'omkar.rakhonde@example.com',
  address: 'Cidco, Chhatrapati Sambhajinagar, Maharashtra',
  profilePhotoUrl: _profilePhotoUrl,
  language: AppLanguage.en,
  theme: AppThemePreference.system,
);
