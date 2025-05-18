import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:budget_wise/core/constants/theme.dart';
import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:budget_wise/data/models/notification.dart';
import 'package:budget_wise/data/models/notification_type.dart';
import 'package:budget_wise/data/models/recurring_transaction_history.dart';
import 'package:budget_wise/data/repositories/analytics_repository.dart';
import 'package:budget_wise/data/repositories/budget_repository.dart';
import 'package:budget_wise/data/repositories/notification_repository.dart';
import 'package:budget_wise/data/repositories/savings_goal_repository.dart';
import 'package:budget_wise/data/repositories/settings_repository.dart';
import 'package:budget_wise/data/repositories/transaction_repository.dart';
import 'package:budget_wise/data/repositories/user_repository.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:budget_wise/presentation/screens/introduction/into_screen.dart';
import 'package:budget_wise/services/analytic_service.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:budget_wise/services/budget_service.dart';

import 'package:budget_wise/services/notification_manager.dart';
import 'package:budget_wise/services/notification_service.dart';
import 'package:budget_wise/services/savings_goal_service.dart';
import 'package:budget_wise/services/settings_service.dart';
import 'package:budget_wise/services/transaction_service.dart';
import 'package:budget_wise/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'data/models/user.dart';
import 'data/models/budget.dart';
import 'data/models/transaction.dart';

import 'data/models/savings_goal.dart';
import 'data/models/analytics.dart';
import 'data/models/settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationManager().init();

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(TransactionAdapter());

  Hive.registerAdapter(SavingsGoalAdapter());
  Hive.registerAdapter(AppNotificationAdapter());
  Hive.registerAdapter(AnalyticsAdapter());
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(BudgetHistoryEntryAdapter());
  Hive.registerAdapter(RecurringTransactionHistoryAdapter());
  Hive.registerAdapter(NotificationTypeAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Budget>('budgets');

  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<SavingsGoal>('savings_goals');
  await Hive.openBox<AppNotification>('notifications');
  await Hive.openBox<Analytics>('analytics');
  await Hive.openBox<Settings>('settings');

  final userRepository = UserRepository();
  final budgetRepository = BudgetRepository();
  final transactionRepository = TransactionRepository();

  final savingsGoalRepository = SavingsGoalRepository();
  final notificationRepository = NotificationRepository();
  final analyticsRepository = AnalyticsRepository();
  final settingsRepository = SettingsRepository();

  AppServices.userService = UserService(userRepository);
  AppServices.budgetService = BudgetService(budgetRepository);
  AppServices.transactionService =
      TransactionService(transactionRepository, budgetRepository);
  AppServices.savingsGoalService = SavingsGoalService(savingsGoalRepository);
  AppServices.notificationService = NotificationService(notificationRepository);
  AppServices.analyticsService = AnalyticsService(analyticsRepository);
  AppServices.settingsService = SettingsService(settingsRepository);

  if (AppServices.budgetService.getBudget() != null) {
    AppServices.analyticsService.fixAnalytics();
  }

  AppServices.transactionService.fixRecurringTransactions();

  NotificationManager manager = NotificationManager();
  manager.checkAllNotification();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    ThemeData appTheme =
        themeMode == ThemeMode.dark ? AppDarkTheme : AppLightTheme;
    return MaterialApp(
      title: 'Budget Wise',
      theme: appTheme,
      home: AnimatedSplashScreen(
        centered: true,
        splashIconSize: 250,
        splash: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 220,
                  width: 200,
                  child: Image.asset(
                    'assets/images/budgetWiseIcon.png',
                  )),
              SizedBox(
                height: 10,
              ),
              Text(
                "Budget Wise !",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              )
            ],
          ),
        ),
        nextScreen: AppServices.budgetService.getBudget() != null
            ? MainScreen()
            : WelcomeScreen(),
        duration: 2600,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
      ),
    );
  }
}
