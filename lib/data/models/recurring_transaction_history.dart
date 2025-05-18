import 'package:hive/hive.dart';
part 'recurring_transaction_history.g.dart';

@HiveType(typeId: 16)
class RecurringTransactionHistory {
  @HiveField(0)
  bool? isAchieved;
  @HiveField(1)
  DateTime? date;

  RecurringTransactionHistory({this.isAchieved, this.date = null});
}
