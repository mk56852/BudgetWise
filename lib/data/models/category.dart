import 'package:hive/hive.dart';
part 'category.g.dart';

@HiveType(typeId: 4)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type; // "income" or "expense"

  @HiveField(3)
  final String? icon;

  @HiveField(4)
  final String? color;

  @HiveField(5)
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
