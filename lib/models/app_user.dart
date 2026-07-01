enum AppLanguage {
  en,
  mr,
  hi;

  String get label => switch (this) {
        AppLanguage.en => 'English',
        AppLanguage.mr => 'Marathi',
        AppLanguage.hi => 'Hindi',
      };
}

enum AppThemePreference {
  light,
  dark,
  system;

  String get label => switch (this) {
        AppThemePreference.light => 'Light',
        AppThemePreference.dark => 'Dark',
        AppThemePreference.system => 'System',
      };
}

class AppUser {
  const AppUser({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.profilePhotoUrl,
    required this.language,
    required this.theme,
  });

  final String userId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String address;
  final String? profilePhotoUrl;
  final AppLanguage language;
  final AppThemePreference theme;
}
