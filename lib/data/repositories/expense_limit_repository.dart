import 'package:hive/hive.dart';
import '../models/expense_limit.dart';

class ExpenseLimitRepository {
  final Box<ExpenseLimit> _box = Hive.box<ExpenseLimit>('expense_limits');

  ExpenseLimitRepository();

  Future<void> addExpenseLimit(ExpenseLimit expenseLimit) async {
    await _box.add(expenseLimit);
  }

  List<ExpenseLimit> getExpenseLimits() {
    return _box.values.toList();
  }

  Future<void> updateExpenseLimit(int index, ExpenseLimit expenseLimit) async {
    await _box.putAt(index, expenseLimit);
  }

  Future<void> deleteExpenseLimit(int index) async {
    await _box.deleteAt(index);
  }
}
