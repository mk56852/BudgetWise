import 'package:budget_wise/services/analytic_service.dart';
import 'package:budget_wise/services/budget_service.dart';
import 'package:budget_wise/services/category_service.dart';
import 'package:budget_wise/services/notification_service.dart';
import 'package:budget_wise/services/savings_goal_service.dart';
import 'package:budget_wise/services/settings_service.dart';
import 'package:budget_wise/services/transaction_service.dart';
import 'package:budget_wise/services/user_service.dart';
import 'package:budget_wise/services/expense_limit_service.dart'; // Import the ExpenseLimitService

class AppServices {
  static late UserService userService;
  static late BudgetService budgetService;
  static late TransactionService transactionService;
  static late CategoryService categoryService;
  static late SavingsGoalService savingsGoalService;
  static late NotificationService notificationService;
  static late AnalyticsService analyticsService;
  static late SettingsService settingsService;
  static late ExpenseLimitService
      expenseLimitService; // Add the ExpenseLimitService
}
