enum OwnerVerificationStatus {
  pending,
  approved,
  rejected,
  suspended;

  String get label => switch (this) {
        OwnerVerificationStatus.pending => 'Pending',
        OwnerVerificationStatus.approved => 'Approved',
        OwnerVerificationStatus.rejected => 'Rejected',
        OwnerVerificationStatus.suspended => 'Suspended',
      };
}

class OwnerProfile {
  final String ownerId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String messName;
  final String businessName;
  final String fssaiLicense;
  final String panNumber;
  final String address;
  final OwnerVerificationStatus verificationStatus;
  final DateTime submissionDate;
  final String? documentUrl;
  final String? rejectionReason;

  const OwnerProfile({
    required this.ownerId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.messName,
    required this.businessName,
    required this.fssaiLicense,
    required this.panNumber,
    required this.address,
    required this.verificationStatus,
    required this.submissionDate,
    this.documentUrl,
    this.rejectionReason,
  });

  OwnerProfile copyWith({
    String? ownerId,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? messName,
    String? businessName,
    String? fssaiLicense,
    String? panNumber,
    String? address,
    OwnerVerificationStatus? verificationStatus,
    DateTime? submissionDate,
    String? documentUrl,
    String? rejectionReason,
  }) {
    return OwnerProfile(
      ownerId: ownerId ?? this.ownerId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      messName: messName ?? this.messName,
      businessName: businessName ?? this.businessName,
      fssaiLicense: fssaiLicense ?? this.fssaiLicense,
      panNumber: panNumber ?? this.panNumber,
      address: address ?? this.address,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      submissionDate: submissionDate ?? this.submissionDate,
      documentUrl: documentUrl ?? this.documentUrl,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
