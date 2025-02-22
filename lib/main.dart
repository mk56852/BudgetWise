import 'package:budget_wise/core/utils/utils.dart';
import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:budget_wise/data/models/notification.dart';
import 'package:budget_wise/data/repositories/analytics_repository.dart';
import 'package:budget_wise/data/repositories/budget_repository.dart';
import 'package:budget_wise/data/repositories/category_repository.dart';
import 'package:budget_wise/data/repositories/notification_repository.dart';
import 'package:budget_wise/data/repositories/savings_goal_repository.dart';
import 'package:budget_wise/data/repositories/settings_repository.dart';
import 'package:budget_wise/data/repositories/transaction_repository.dart';
import 'package:budget_wise/data/repositories/user_repository.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:budget_wise/services/analytic_service.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:budget_wise/services/budget_service.dart';
import 'package:budget_wise/services/category_service.dart';
import 'package:budget_wise/services/notification_service.dart';
import 'package:budget_wise/services/savings_goal_service.dart';
import 'package:budget_wise/services/settings_service.dart';
import 'package:budget_wise/services/transaction_service.dart';
import 'package:budget_wise/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'data/models/user.dart';
import 'data/models/budget.dart';
import 'data/models/money_source.dart';
import 'data/models/transaction.dart';
import 'data/models/category.dart';
import 'data/models/savings_goal.dart';
import 'data/models/analytics.dart';
import 'data/models/settings.dart';
import 'data/models/expense_limit.dart'; // Import the ExpenseLimit model
import 'data/repositories/expense_limit_repository.dart'; // Import the ExpenseLimitRepository
import 'services/expense_limit_service.dart'; // Import the ExpenseLimitService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(MoneySourceAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(SavingsGoalAdapter());
  Hive.registerAdapter(AppNotificationAdapter());
  Hive.registerAdapter(AnalyticsAdapter());
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(BudgetHistoryEntryAdapter());

  Hive.registerAdapter(
      ExpenseLimitAdapter()); // Register the ExpenseLimit adapter

  await Hive.openBox<User>('users');
  await Hive.openBox<Budget>('budgets');
  await Hive.openBox<MoneySource>('money_sources');
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<Category>('categories');
  await Hive.openBox<SavingsGoal>('savings_goals');
  await Hive.openBox<AppNotification>('notifications');
  await Hive.openBox<Analytics>('analytics');
  await Hive.openBox<Settings>('settings');
  await Hive.openBox<ExpenseLimit>('expense_limits');

  final userRepository = UserRepository();
  final budgetRepository = BudgetRepository();
  final transactionRepository = TransactionRepository();
  final categoryRepository = CategoryRepository();
  final savingsGoalRepository = SavingsGoalRepository();
  final notificationRepository = NotificationRepository();
  final analyticsRepository = AnalyticsRepository();
  final settingsRepository = SettingsRepository();
  final expenseLimitRepository =
      ExpenseLimitRepository(); // Initialize the ExpenseLimitRepository

  AppServices.userService = UserService(userRepository);
  AppServices.budgetService = BudgetService(budgetRepository);
  AppServices.transactionService =
      TransactionService(transactionRepository, budgetRepository);
  AppServices.categoryService = CategoryService(categoryRepository);
  AppServices.savingsGoalService = SavingsGoalService(savingsGoalRepository);
  AppServices.notificationService = NotificationService(notificationRepository);
  AppServices.analyticsService = AnalyticsService(analyticsRepository);
  AppServices.settingsService = SettingsService(settingsRepository);
  AppServices.expenseLimitService = ExpenseLimitService(
      expenseLimitRepository); // Add the ExpenseLimitService

  Budget? budget = AppServices.budgetService.getBudget();
  if (budget == null) {
    AppServices.budgetService.addBudget(Budget(
        id: generateId("Budget:"), amount: 0, lastUpdated: DateTime.now()));
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Wise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}
