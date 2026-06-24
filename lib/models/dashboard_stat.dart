class DashboardStat {
  final String title;
  final String value;
  final String? subtitle;
  final String category; // 'platform', 'approval', 'health', 'revenue'
  final bool? isTrendPositive;
  final String? trendValue;

  const DashboardStat({
    required this.title,
    required this.value,
    this.subtitle,
    required this.category,
    this.isTrendPositive,
    this.trendValue,
  });

  DashboardStat copyWith({
    String? title,
    String? value,
    String? subtitle,
    String? category,
    bool? isTrendPositive,
    String? trendValue,
  }) {
    return DashboardStat(
      title: title ?? this.title,
      value: value ?? this.value,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      isTrendPositive: isTrendPositive ?? this.isTrendPositive,
      trendValue: trendValue ?? this.trendValue,
    );
  }
}
