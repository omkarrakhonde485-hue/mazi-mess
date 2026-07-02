import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_repository_provider.dart';
import '../../../core/router/app_router.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      setState(() {
        _errorText = 'OTP cannot be empty';
      });
      return;
    }

    final otpPattern = RegExp(r'^\d{6}$');
    if (!otpPattern.hasMatch(otp)) {
      setState(() {
        _errorText = 'Enter a valid 6-digit OTP';
      });
      return;
    }

    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    final state = GoRouterState.of(context);
    final extra = state.extra as Map<String, dynamic>?;
    final verificationId = extra?['verificationId'] as String? ?? state.uri.queryParameters['verificationId'] ?? '';

    if (verificationId.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Verification ID is missing. Please request OTP again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    try {
      await ref.read(authRepositoryProvider).verifyOtp(
        verificationId: verificationId,
        smsCode: otp,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Verified Successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      context.pop(); // Return to the previous screen
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter OTP',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A 6-digit code was sent to your mobile number',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _otpController,
                enabled: !_isLoading,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (value) {
                  if (_errorText != null) {
                    setState(() {
                      _errorText = null;
                    });
                  }
                },
                style: textTheme.titleLarge?.copyWith(
                  letterSpacing: 8,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: '000000',
                  counterText: '',
                  prefixIcon: const Icon(Icons.lock_outline),
                  errorText: _errorText,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _verifyOtp,
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Text('Verify'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _isLoading ? null : () => context.go(AppRoute.login.path),
                child: const Text('Change mobile number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
