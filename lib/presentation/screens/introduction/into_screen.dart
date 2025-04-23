import 'package:budget_wise/core/utils/utils.dart';
import 'package:budget_wise/data/models/analytics.dart';
import 'package:budget_wise/data/models/budget.dart';
import 'package:budget_wise/data/models/user.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController newCurrencyController = TextEditingController();
  final TextEditingController budgetController =
      TextEditingController(text: '0');
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      overrideSkip: SizedBox(),
      pages: [
        PageViewModel(
          title: "Welcome to BudgetWise",
          body:
              "BudgetWise is here to empower you to manage your finances—no matter what currency you use. Whether it’s dollars, euros, yen, or any other, our app ensures every transaction counts. Start your journey toward financial clarity and freedom—because you deserve a smarter way to manage your money.",
          image: Center(
            child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(
                  "assets/images/budgetWiseIcon.png",
                  fit: BoxFit.cover,
                )),
          ),
        ),
        PageViewModel(
          title: "Get Started",
          bodyWidget: Column(
            children: [
              Text("Let us know a bit about you:"),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Your Name",
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: budgetController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Budget Amount",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: newCurrencyController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Currency",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          image: Center(
            child: SizedBox(
                height: 250,
                width: 300,
                child: Image.asset(
                  "assets/images/screen2.png",
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ],
      onDone: () {
        // Validation logic
        if (nameController.text.isEmpty ||
            budgetController.text.isEmpty ||
            newCurrencyController.text.isEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Missing Information"),
                content: Text("Please fill in all fields."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
          return; // Exit the function if validation fails
        }

        // Proceed with user creation
        String userName = nameController.text;

        User newUser = User(
          id: generateId("user"),
          name: userName,
          currency: newCurrencyController.text,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );
        Budget currentBudget = Budget(
            id: generateId("budget:"),
            amount: double.parse(budgetController.text),
            lastAmount: 0,
            lastUpdated: DateTime.now());
        AppServices.budgetService.addBudget(currentBudget);
        DateTime time = DateTime.now();
        AppServices.analyticsService.addAnalytics(Analytics(
            id: generateId("Analytics:"),
            month: time.month,
            year: time.year,
            incomeTotal: 0,
            expenseTotal: 0,
            totalBudget: 0,
            savedForGoal: 0));
        AppServices.userService.addUser(newUser).then((_) {
          // Show Lottie animation
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: Lottie.asset('assets/images/Animation.json'),
            ),
          );

          // Wait for 3 seconds before navigating
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    MainScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var tween = Tween(begin: 0.0, end: 1.0)
                      .chain(CurveTween(curve: Curves.ease));
                  return ScaleTransition(
                    scale: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          });
        });
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.deepPurple,
        color: Colors.black26,
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
