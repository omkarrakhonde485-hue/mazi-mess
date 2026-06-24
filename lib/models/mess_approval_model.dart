enum MessApprovalStatus {
  pending,
  approved,
  rejected,
  suspended;

  String get label => switch (this) {
        MessApprovalStatus.pending => 'Pending',
        MessApprovalStatus.approved => 'Approved',
        MessApprovalStatus.rejected => 'Rejected',
        MessApprovalStatus.suspended => 'Suspended',
      };
}

enum MessRejectionReasonType {
  invalidFssai,
  incompleteDocuments,
  addressMismatch,
  duplicateListing,
  other;

  String get label => switch (this) {
        MessRejectionReasonType.invalidFssai => 'Invalid FSSAI License',
        MessRejectionReasonType.incompleteDocuments => 'Incomplete Documents',
        MessRejectionReasonType.addressMismatch => 'Address Mismatch',
        MessRejectionReasonType.duplicateListing => 'Duplicate Listing',
        MessRejectionReasonType.other => 'Other',
      };
}

class MessApproval {
  final String messId;
  final String messName;
  final String ownerName;
  final String ownerId;
  final String description;
  final String address;
  final String foodType; // e.g. Veg, Non-Veg, Veg & Non-Veg
  final int startingPrice;
  final String fssaiLicense;
  final String? fssaiDocumentUrl;
  final String? menuDocumentUrl;
  final String contactNumber;
  final String email;
  final DateTime submissionDate;
  final MessApprovalStatus status;
  final MessRejectionReasonType? rejectionReasonType;
  final String? rejectionReasonDetails;

  const MessApproval({
    required this.messId,
    required this.messName,
    required this.ownerName,
    required this.ownerId,
    required this.description,
    required this.address,
    required this.foodType,
    required this.startingPrice,
    required this.fssaiLicense,
    this.fssaiDocumentUrl,
    this.menuDocumentUrl,
    required this.contactNumber,
    required this.email,
    required this.submissionDate,
    required this.status,
    this.rejectionReasonType,
    this.rejectionReasonDetails,
  });

  MessApproval copyWith({
    String? messId,
    String? messName,
    String? ownerName,
    String? ownerId,
    String? description,
    String? address,
    String? foodType,
    int? startingPrice,
    String? fssaiLicense,
    String? fssaiDocumentUrl,
    String? menuDocumentUrl,
    String? contactNumber,
    String? email,
    DateTime? submissionDate,
    MessApprovalStatus? status,
    MessRejectionReasonType? rejectionReasonType,
    String? rejectionReasonDetails,
  }) {
    return MessApproval(
      messId: messId ?? this.messId,
      messName: messName ?? this.messName,
      ownerName: ownerName ?? this.ownerName,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
      address: address ?? this.address,
      foodType: foodType ?? this.foodType,
      startingPrice: startingPrice ?? this.startingPrice,
      fssaiLicense: fssaiLicense ?? this.fssaiLicense,
      fssaiDocumentUrl: fssaiDocumentUrl ?? this.fssaiDocumentUrl,
      menuDocumentUrl: menuDocumentUrl ?? this.menuDocumentUrl,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      submissionDate: submissionDate ?? this.submissionDate,
      status: status ?? this.status,
      rejectionReasonType: rejectionReasonType ?? this.rejectionReasonType,
      rejectionReasonDetails: rejectionReasonDetails ?? this.rejectionReasonDetails,
    );
  }
}
