enum NoticeCategory {
  general,
  holiday,
  menuChange,
  paymentReminder,
  emergency;

  String get label => switch (this) {
        NoticeCategory.general => 'General',
        NoticeCategory.holiday => 'Holiday',
        NoticeCategory.menuChange => 'Menu Change',
        NoticeCategory.paymentReminder => 'Payment Reminder',
        NoticeCategory.emergency => 'Emergency',
      };
}

class Notice {
  const Notice({
    required this.noticeId,
    required this.title,
    required this.category,
    required this.date,
  });

  final String noticeId;
  final String title;
  final NoticeCategory category;
  final DateTime date;
}
