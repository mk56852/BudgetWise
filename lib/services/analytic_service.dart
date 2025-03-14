import 'package:budget_wise/services/app_services.dart';

import '../data/models/analytics.dart';
import '../data/repositories/analytics_repository.dart';

class AnalyticsService {
  final AnalyticsRepository _analyticsRepository;

  AnalyticsService(this._analyticsRepository);

  // Add new analytics data
  Future<void> addAnalytics(Analytics analytics) async {
    await _analyticsRepository.addAnalytics(analytics);
  }

  // Get analytics data by ID
  Analytics? getCurrentMonthAnalytics() {
    return _analyticsRepository.getCurrentAnalytics();
  }

  // Update analytics data
  Future<void> updateAnalytics(Analytics analytics) async {
    await _analyticsRepository.updateAnalytics(analytics);
  }

  // Delete analytics data
  Future<void> deleteAnalytics(String id) async {
    await _analyticsRepository.deleteAnalytics(id);
  }

  void fixAnalytics() {
    DateTime today = DateTime.now();
    Analytics analytics = getCurrentMonthAnalytics()!;
    if (analytics.month != today.month) {
      double budgetAmount = AppServices.budgetService.getBudget()!.amount;
      double totalSaves = AppServices.savingsGoalService.getAllSavedAmount();
      double totalExpense = AppServices.transactionService
          .calculateTotalExpensesByMonth(analytics.year, analytics.month);
      double totalIncome = AppServices.transactionService
          .calculateTotalIncomeByMonth(analytics.year, analytics.month);

      analytics.incomeTotal = totalIncome;
      analytics.totalBudget = budgetAmount;
      analytics.expenseTotal = totalExpense;
      analytics.savedForGoal = totalSaves;
      updateAnalytics(analytics);
    }
  }
}
