import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/analytics/analytics_screen.dart';
import 'package:budget_wise/presentation/screens/goals/SavingsGoalsList.dart';
import 'package:budget_wise/presentation/screens/goals/add_goal_screen.dart';
import 'package:budget_wise/presentation/screens/home/home_screen.dart';
import 'package:budget_wise/presentation/screens/transactions/add_transaction_screen.dart';
import 'package:budget_wise/presentation/screens/transactions/transactions_screen.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:budget_wise/services/pdf_exporter.dart';
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

final List<SalomonBottomBarItem> bottomNavItems = [
  SalomonBottomBarItem(
    icon: Icon(Icons.home),
    title: Text("Home"),
    selectedColor: Colors.white, // Primary color
  ),
  SalomonBottomBarItem(
    icon: Icon(Icons.list),
    title: Text("Transactions"),
    selectedColor: Colors.white,
  ),
  SalomonBottomBarItem(
    icon: Icon(Icons.savings),
    title: Text("Goals"),
    selectedColor: Colors.white,
  ),
  SalomonBottomBarItem(
    icon: Icon(Icons.analytics),
    title: Text("Analytics"),
    selectedColor: Colors.white,
  ),
];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  int _currentIndex = 0;

  List<Widget?> get _floatingButton => [
        null,
        _generate_transaction_floating_button(),
        _generate_transaction_floating_button(),
        _generate_analytics_floating_button()
      ];

  List<Widget> get _screens => [
        HomeScreen(navigate: updateScreen),
        TransactionsScreen(),
        SavingsGoalListScreen(),
        AnalyticsScreen(),
      ];

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  void updateScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black87, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: _generateDrawer(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkBlueColor,
                  Colors.black,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: SingleChildScrollView(child: _screens[_currentIndex]),
              ),
            ),
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,

            onTap: (index) {
              updateScreen(index);
            },
            items: bottomNavItems,
            selectedItemColor: Colors.white, // Primary color
            unselectedItemColor:
                Colors.white.withOpacity(0.8), // Unselected color
            backgroundColor: Colors.black, // Dark background
          ),
          floatingActionButton: _floatingButton[_currentIndex]),
    );
  }

  Widget _generate_transaction_floating_button() {
    return LayoutBuilder(
      builder: (context, constraints) => FabCircularMenuPlus(
          fabColor: Colors.blueAccent.withOpacity(0.9),
          fabChild: Icon(
            Icons.add,
            color: Colors.white,
          ),
          ringColor: Colors.blue.withOpacity(1),
          ringWidth: constraints.maxWidth * 0.22,
          ringDiameter: constraints.maxWidth * 0.9,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTransactionScreen())),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text("tranasction", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddSavingsGoalScreen())),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text("saving goal", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _generate_analytics_floating_button() {
    return LayoutBuilder(
      builder: (context, constraints) => FabCircularMenuPlus(
          fabColor: Colors.blueAccent.withOpacity(0.9),
          fabChild: Icon(
            Icons.download,
            color: Colors.white,
          ),
          ringColor: Colors.blue.withOpacity(1),
          ringWidth: constraints.maxWidth * 0.22,
          ringDiameter: constraints.maxWidth * 0.9,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTransactionScreen())),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "generate this",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text("month pdf", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            InkWell(
              onTap: () => exportCurrentMonthData(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "generate",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text("custom pdf", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ]),
    );
  }

  void exportCurrentMonthData() async {
    DateTime now = DateTime.now();
    int expensesNumber = AppServices.transactionService
        .getExpensesFromMonthYear(now.year, now.month)
        .length;
    int incomesNumber = AppServices.transactionService
        .getIncomesFromMonthYear(now.year, now.month)
        .length;

    String currency = AppServices.userService.getCurrentUser()!.currency;
    double expenseTotal = AppServices.transactionService
        .calculateTotalExpensesByMonth(now.year, now.month);

    double incomeTotal = AppServices.transactionService
        .calculateTotalIncomeByMonth(now.year, now.month);
    double netTotal = incomeTotal - expenseTotal;

    List<Transaction> transactions = await AppServices.transactionService
        .getAllTranasactionsForMonth(now.year, now.month);

    List<Map<String, dynamic>> sampleData =
        transactions.map((item) => item.toJson()).toList();
    List<Map<String, String>> generalInfo = [
      {
        "title": "Total Incomes",
        "value": "$incomesNumber transactions",
        "amount": "$incomeTotal $currency"
      },
      {
        "title": "Total Expenses",
        "value": "$expensesNumber transactions",
        "amount": "$expenseTotal $currency"
      },
      {
        "title": "Net Balance",
        "value": "current month balance",
        "amount": "$netTotal $currency"
      },
    ];

    await PdfExporter.exportToPdf("Monthly Report", generalInfo, sampleData,
        await AppServices.budgetService.getAllHistory());
  }

  Widget _generateDrawer() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              AppColors.darkBlueColor,
              Colors.black,
            ],
          ),
        ),
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/drag.png',
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.home),
                title: Text('Home'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.account_circle_rounded),
                title: Text('Profile'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.favorite),
                title: Text('Donation'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainContainer extends StatelessWidget {
  final Widget child;
  const MainContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              AppColors.darkBlueColor,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );
  }
}
