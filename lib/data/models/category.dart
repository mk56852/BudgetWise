class Category {
  final String id;

  final String name;

  final String type; // "income" or "expense"

  final String? icon;

  final String? color;

  final double? budgetLimit;

  Category({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    this.budgetLimit,
  });
}
