class Plan {
  const Plan({
    required this.planId,
    required this.messId,
    required this.planName,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.mealTypes,
    required this.isActive,
  });

  final String planId;
  final String messId;
  final String planName;
  final String description;
  final int price;
  final int durationDays;
  final List<String> mealTypes;
  final bool isActive;
}
