import 'package:budget_wise/core/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'transaction.g.dart';

@HiveType(typeId: 3)
class Transaction {
  @HiveField(0)
  String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  String? categoryId;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final bool isRecurring;

  @HiveField(7)
  bool isAchieved;

  @HiveField(8) // Next available field ID
  Map<String, bool?> monthlyAchievements;

  Transaction(
      {required this.id,
      required this.type,
      required this.amount,
      this.categoryId,
      required this.date,
      this.description,
      this.isRecurring = false,
      this.isAchieved = false,
      this.monthlyAchievements = const {}});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'categoryId': categoryId,
      'date': DateFormat.yMd().format(date),
      'description': description,
    };
  }

  bool isTranasctionAchievedForMonth(int year, int month) {
    DateTime date = DateTime(year, month, 1);
    bool? isItAchieved = monthlyAchievements[getMonthYearKey(date)];
    if (isItAchieved == null)
      return false;
    else
      return isItAchieved!;
  }

  bool isTranAchieved() {
    if (isRecurring)
      return isTransactionAchievedForCurrentMonth();
    else
      return isAchieved;
  }

  bool isTransactionAchievedForCurrentMonth() {
    DateTime now = DateTime.now();
    bool? isItAchieved = monthlyAchievements[getMonthYearKey(now)];
    if (isItAchieved == null)
      return false;
    else
      return isItAchieved!;
  }

  void fixRecurringTransaction() {
    DateTime now = DateTime.now();
    List<String> months = getMonthsBetween(date, now);
    for (int i = 0; i < months.length - 1; i++) {
      bool? isItAchieved = monthlyAchievements[getMonthYearKey(now)];
      if (isItAchieved == null) {
        monthlyAchievements[getMonthYearKey(now)] = false;
      }
    }
  }
}
