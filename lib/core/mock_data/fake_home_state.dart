import 'package:flutter/material.dart';

enum QrStatus {
  qrAvailable,
  alreadyUsed,
  leaveDay,
  noActiveSubscription;

  String get label => switch (this) {
        QrStatus.qrAvailable => 'QR Available',
        QrStatus.alreadyUsed => 'Already Used',
        QrStatus.leaveDay => 'Leave Day',
        QrStatus.noActiveSubscription => 'No Active Subscription',
      };

  IconData get icon => switch (this) {
        QrStatus.qrAvailable => Icons.qr_code_2,
        QrStatus.alreadyUsed => Icons.qr_code_scanner,
        QrStatus.leaveDay => Icons.event_busy_outlined,
        QrStatus.noActiveSubscription => Icons.block_outlined,
      };
}

/// Placeholder QR status for the home screen. No generation logic.
const fakeHomeQrStatus = QrStatus.qrAvailable;
