import 'package:hive/hive.dart';

part 'expense_limit.g.dart';

@HiveType(typeId: 13)
class ExpenseLimit {
  @HiveField(0)
  String categoryName;

  @HiveField(1)
  double limit;

  ExpenseLimit({required this.categoryName, required this.limit});

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'limit': limit,
    };
  }

  factory ExpenseLimit.fromJson(Map<String, dynamic> json) {
    return ExpenseLimit(
      categoryName: json['categoryName'],
      limit: json['limit'],
    );
  }
}
