import '../../models/notice_model.dart';

final fakeNotices = <Notice>[
  Notice(
    noticeId: 'notice_001',
    title: 'Sunday holiday — mess closed',
    category: NoticeCategory.holiday,
    date: DateTime(2026, 6, 8),
  ),
  Notice(
    noticeId: 'notice_002',
    title: 'New summer menu starts Monday',
    category: NoticeCategory.menuChange,
    date: DateTime(2026, 6, 5),
  ),
  Notice(
    noticeId: 'notice_003',
    title: 'June subscription payment reminder',
    category: NoticeCategory.paymentReminder,
    date: DateTime(2026, 6, 1),
  ),
];
