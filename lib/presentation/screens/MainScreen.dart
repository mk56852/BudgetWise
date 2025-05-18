import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/theme.dart';
import 'package:budget_wise/presentation/screens/analytics/analytics_screen.dart';
import 'package:budget_wise/presentation/screens/goals/SavingsGoalsList.dart';
import 'package:budget_wise/presentation/screens/goals/add_goal_screen.dart';
import 'package:budget_wise/presentation/screens/home/home_screen.dart';
import 'package:budget_wise/presentation/screens/transactions/add_transaction_screen.dart';
import 'package:budget_wise/presentation/screens/transactions/transactions_screen.dart';
import 'package:budget_wise/services/pdf_exporter.dart';
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  void updateScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get _screens => [
        HomeScreen(navigate: updateScreen),
        TransactionsScreen(),
        SavingsGoalListScreen(),
        AnalyticsScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    ThemeData appTheme =
        themeMode == ThemeMode.dark ? AppDarkTheme : AppLightTheme;

    List<Widget?> _floatingButton = [
      null,
      _generate_transaction_floating_button(appTheme),
      _generate_transaction_floating_button(appTheme),
      _generate_analytics_floating_button(appTheme)
    ];

    final List<SalomonBottomBarItem> bottomNavItems = [
      SalomonBottomBarItem(
        icon: Icon(Icons.home),
        title: Text("Home"),
        unselectedColor: appTheme.extension<AppTheme>()!.iconColor,
        selectedColor:
            appTheme.extension<AppTheme>()!.iconColor, // Primary color
      ),
      SalomonBottomBarItem(
        icon: Icon(Icons.list),
        title: Text("Transactions"),
        unselectedColor: appTheme.extension<AppTheme>()!.iconColor,
        selectedColor: appTheme.extension<AppTheme>()!.iconColor,
      ),
      SalomonBottomBarItem(
        icon: Icon(Icons.savings),
        title: Text("Goals"),
        unselectedColor: appTheme.extension<AppTheme>()!.iconColor,
        selectedColor: appTheme.extension<AppTheme>()!.iconColor,
      ),
      SalomonBottomBarItem(
        icon: Icon(Icons.analytics),
        title: Text("Analytics"),
        unselectedColor: appTheme.extension<AppTheme>()!.iconColor,
        selectedColor: appTheme.extension<AppTheme>()!.iconColor,
      ),
    ];

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) => Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              gradient: appTheme.brightness == Brightness.light
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(220, 220, 225, 1),
                        Colors.white,
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.darkBlueColor,
                        Colors.black,
                      ],
                    ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Opacity(
                          opacity: themeMode == ThemeMode.dark ? 0.055 : 0.15,
                          child: Image.asset(
                              themeMode == ThemeMode.dark
                                  ? "assets/images/pngegg.png"
                                  : "assets/images/pngegg_light.png",
                              fit: BoxFit.fitHeight))),
                  SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20),
                          child: _screens[_currentIndex])),
                ],
              ),
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
          backgroundColor:
              appTheme.extension<AppTheme>()!.bottomBarColor, // Dark background
        ),
        floatingActionButton: _floatingButton[_currentIndex]);
  }

  Widget _generate_transaction_floating_button(ThemeData theme) {
    Color color1 = theme.brightness == Brightness.dark
        ? Colors.white
        : AppColors.darkBlueColor;
    Color color2 =
        theme.brightness == Brightness.dark ? Colors.black : Colors.white;
    return LayoutBuilder(
      builder: (context, constraints) => FabCircularMenuPlus(
          fabColor: color1,
          fabChild: Icon(
            Icons.add,
            color: color2,
          ),
          ringColor: color1,
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
                    style: TextStyle(color: color2),
                  ),
                  Text("tranasction", style: TextStyle(color: color2)),
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
                    style: TextStyle(color: color2),
                  ),
                  Text("saving goal", style: TextStyle(color: color2)),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _generate_analytics_floating_button(ThemeData theme) {
    Color color1 = theme.brightness == Brightness.dark
        ? Colors.white
        : AppColors.darkBlueColor;
    Color color2 =
        theme.brightness == Brightness.dark ? Colors.black : Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) => FabCircularMenuPlus(
          fabColor: color1,
          fabChild: Icon(
            Icons.download,
            color: color2,
          ),
          ringColor: color1,
          ringWidth: constraints.maxWidth * 0.22,
          ringDiameter: constraints.maxWidth * 0.9,
          children: <Widget>[
            InkWell(
              onTap: () => PdfExporter.exportCurrentMonthData(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "generate this",
                    style: TextStyle(color: color2),
                  ),
                  Text("month pdf", style: TextStyle(color: color2)),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    DateTime? startDate;
                    DateTime? endDate;
                    return AlertDialog(
                      title: Text("Select Date Range"),
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Select Date Range",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 20),
                                Text(
                                    "Start Date: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : 'Not selected'}"),
                                TextButton(
                                  onPressed: () async {
                                    startDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    setState(
                                        () {}); // Refresh to show selected date
                                  },
                                  child: Text("Select Start Date"),
                                ),
                                SizedBox(height: 20),
                                Text(
                                    "End Date: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'Not selected'}"),
                                TextButton(
                                  onPressed: () async {
                                    endDate = await showDatePicker(
                                      context: context,
                                      initialDate: startDate ?? DateTime.now(),
                                      firstDate: startDate ?? DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    setState(
                                        () {}); // Refresh to show selected date
                                  },
                                  child: Text("Select End Date"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (startDate != null && endDate != null) {
                              PdfExporter.exportCustomData(
                                  context, startDate!, endDate!);
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text("Submit"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "generate",
                    style: TextStyle(color: color2),
                  ),
                  Text("custom pdf", style: TextStyle(color: color2)),
                ],
              ),
            ),
          ]),
    );
  }
}

class MainContainer extends ConsumerWidget {
  final Widget child;
  const MainContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    ThemeData appTheme =
        themeMode == ThemeMode.dark ? AppDarkTheme : AppLightTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            gradient: appTheme.brightness == Brightness.light
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(220, 220, 225, 1),
                      Colors.white,
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.darkBlueColor,
                      Colors.black,
                    ],
                  ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Opacity(
                        opacity: themeMode == ThemeMode.dark ? 0.06 : 0.15,
                        child: Image.asset(
                            themeMode == ThemeMode.dark
                                ? "assets/images/pngegg.png"
                                : "assets/images/pngegg_light.png",
                            fit: BoxFit.fitHeight))),
                SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 20),
                        child: child)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
