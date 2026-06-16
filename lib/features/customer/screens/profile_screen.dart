import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_repository_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../models/user_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = ref.read(authRepositoryProvider).getCurrentUser();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
    );
  }

  Future<void> _logout() async {
    await ref.read(authRepositoryProvider).logout();
    if (!mounted) return;
    context.go(AppRoute.login.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('Profile not found'));
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileHeader(user: user),
                  const SizedBox(height: 32),
                  _ProfileInfoSection(user: user),
                  const SizedBox(height: 32),
                  _SettingsSection(
                    user: user,
                    onEditProfile: () => _showComingSoon('Edit Profile'),
                    onChangeMobile: () => _showComingSoon('Change Mobile Number'),
                    onLanguage: () => _showComingSoon('Language'),
                    onTheme: () => _showComingSoon('Theme'),
                    onLogout: _logout,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 52,
          backgroundColor: colorScheme.primaryContainer,
          backgroundImage: user.profilePhotoUrl != null
              ? NetworkImage(user.profilePhotoUrl!)
              : null,
          child: user.profilePhotoUrl == null
              ? Icon(
                  Icons.person,
                  size: 52,
                  color: colorScheme.onPrimaryContainer,
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProfileInfoSection extends StatelessWidget {
  const _ProfileInfoSection({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoTile(
              icon: Icons.phone_outlined,
              label: 'Mobile',
              value: user.phoneNumber,
            ),
            const Divider(height: 24),
            _InfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: user.email,
            ),
            const Divider(height: 24),
            _InfoTile(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: user.address,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.user,
    required this.onEditProfile,
    required this.onChangeMobile,
    required this.onLanguage,
    required this.onTheme,
    required this.onLogout,
  });

  final User user;
  final VoidCallback onEditProfile;
  final VoidCallback onChangeMobile;
  final VoidCallback onLanguage;
  final VoidCallback onTheme;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: onEditProfile,
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.phone_android_outlined,
            title: 'Change Mobile Number',
            onTap: onChangeMobile,
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: user.language.label,
            onTap: onLanguage,
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: user.theme.label,
            onTap: onTheme,
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            titleColor: colorScheme.error,
            iconColor: colorScheme.error,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.titleColor,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: iconColor ?? colorScheme.onSurfaceVariant),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
