import '../data/repositories/expense_limit_repository.dart';
import '../data/models/expense_limit.dart';

class ExpenseLimitService {
  final ExpenseLimitRepository _repository;

  ExpenseLimitService(this._repository);

  Future<void> addExpenseLimit(String categoryName, double limit) async {
    final expenseLimit = ExpenseLimit(categoryName: categoryName, limit: limit);
    await _repository.addExpenseLimit(expenseLimit);
  }

  List<ExpenseLimit> getExpenseLimits() {
    return _repository.getExpenseLimits();
  }

  Future<void> updateExpenseLimit(
      int index, String categoryName, double limit) async {
    final expenseLimit = ExpenseLimit(categoryName: categoryName, limit: limit);
    await _repository.updateExpenseLimit(index, expenseLimit);
  }

  Future<void> deleteExpenseLimit(int index) async {
    await _repository.deleteExpenseLimit(index);
  }
}
