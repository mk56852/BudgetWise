import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/categories.dart';
import 'package:budget_wise/data/models/expense_limit.dart';
import 'package:budget_wise/data/models/settings.dart';
import 'package:budget_wise/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:budget_wise/services/app_services.dart'; // Importing AppServices

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Box<User> userBox;
  late Box<Settings> settingsBox;

  late TextEditingController nameController;
  late TextEditingController currencyController;
  late TextEditingController languageController;
  late bool notificationsEnabled;
  late bool limitNotificationsEnabled;
  late bool weeklyLimitEnabled;
  late bool monthlyLimitEnabled;
  late String theme;
  late double? weeklyLimit;
  late double? monthlyLimit;
  late String? userImage;

  User? user;
  Settings? settings;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    userBox = Hive.box<User>('users');
    settingsBox = Hive.box<Settings>('settings');

    if (userBox.isNotEmpty && settingsBox.isNotEmpty) {
      user = userBox.getAt(0);
      settings = settingsBox.getAt(0);

      if (user != null && settings != null) {
        setState(() {
          nameController = TextEditingController(text: user!.name);
          currencyController = TextEditingController(text: user!.currency);
          languageController =
              TextEditingController(text: settings!.language ?? '');

          theme = settings!.theme;
          notificationsEnabled = settings!.notificationsEnabled;
          limitNotificationsEnabled = settings!.limitNotificationsEnabled;
          weeklyLimitEnabled = settings!.weeklyLimitEnabled;
          monthlyLimitEnabled = settings!.monthlyLimitEnabled;
          weeklyLimit = settings!.weeklyLimit;
          monthlyLimit = settings!.monthlyLimit;
        });
      }
    }
  }

  void _saveChanges() {
    if (user != null && settings != null) {
      user = User(
        id: user!.id,
        name: nameController.text,
        currency: currencyController.text,
        createdAt: user!.createdAt,
        lastLogin: DateTime.now(),
      );

      settings = Settings(
        id: settings!.id,
        theme: theme,
        notificationsEnabled: notificationsEnabled,
        limitNotificationsEnabled: limitNotificationsEnabled,
        currency: currencyController.text,
        defaultView: settings!.defaultView,
        backupPath: settings!.backupPath,
        weeklyLimit: weeklyLimit,
        monthlyLimit: monthlyLimit,
        weeklyLimitEnabled: weeklyLimitEnabled,
        monthlyLimitEnabled: monthlyLimitEnabled,
        language: languageController.text,
      );

      userBox.put(user!.id, user!);
      settingsBox.put(settings!.id, settings!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Wrap(
          runSpacing: 5,
          spacing: 5,
          children: [
            ...appCategoriesWithIcons.map((category) {
              // Retrieve the expense limits
              final expenseLimits =
                  AppServices.expenseLimitService.getExpenseLimits();
              final limit = expenseLimits
                  .firstWhere(
                    (expenseLimit) =>
                        expenseLimit.categoryName == category.name,
                    orElse: () =>
                        ExpenseLimit(categoryName: category.name, limit: 0),
                  )
                  .limit;

              return GestureDetector(
                onTap: () {
                  TextEditingController limitController =
                      TextEditingController(text: limit.toString());
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Update Limit for ${category.name}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: limitController,
                              decoration: InputDecoration(
                                labelText: 'Limit',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                double newLimit =
                                    double.tryParse(limitController.text) ??
                                        limit;

                                // Check if the limit already exists
                                int index = expenseLimits.indexWhere(
                                    (e) => e.categoryName == category.name);

                                if (index != -1) {
                                  // Update existing limit
                                  AppServices.expenseLimitService
                                      .updateExpenseLimit(
                                          index, category.name, newLimit);
                                } else {
                                  // Add new limit if it doesn't exist
                                  AppServices.expenseLimitService
                                      .addExpenseLimit(
                                    category.name,
                                    newLimit,
                                  );
                                }

                                setState(() {
                                  // Refresh the screen to show updated limits
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: _CategoryLimitWidget(
                    name: category.name,
                    icon: category.icon,
                    limit: limit, // Set limit from expense limits
                    usedAmount: AppServices.transactionService
                            .getTotalExpensesForCategories()[category.name] ??
                        0 // Retrieve used amount
                    ),
              );
            }).toList(),
          ],
        ),
        // User Input Fields with Icons
        TextField(
          controller: nameController,
          style: TextStyle(color: Colors.white), // Light text color
          decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            prefixIcon: Icon(Icons.person, color: Colors.grey), // Added icon
          ),
        ),
        TextField(
          controller: currencyController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Currency',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            prefixIcon: Icon(Icons.money, color: Colors.grey), // Added icon
          ),
        ),
        TextField(
          controller: languageController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Language',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            prefixIcon: Icon(Icons.language, color: Colors.grey), // Added icon
          ),
        ),

        // Switches
        SwitchListTile(
          title: Text('Enable Notifications',
              style: TextStyle(color: Colors.white)),
          value: notificationsEnabled,
          onChanged: (value) {
            setState(() => notificationsEnabled = value);
          },
        ),
        SwitchListTile(
          title: Text('Limit Notifications',
              style: TextStyle(color: Colors.white)),
          value: limitNotificationsEnabled,
          onChanged: (value) {
            setState(() => limitNotificationsEnabled = value);
          },
        ),
        SwitchListTile(
          title: Text('Weekly Limit Enabled',
              style: TextStyle(color: Colors.white)),
          value: weeklyLimitEnabled,
          onChanged: (value) {
            setState(() => weeklyLimitEnabled = value);
          },
        ),
        SwitchListTile(
          title: Text('Monthly Limit Enabled',
              style: TextStyle(color: Colors.white)),
          value: monthlyLimitEnabled,
          onChanged: (value) {
            setState(() => monthlyLimitEnabled = value);
          },
        ),
        SizedBox(height: 20),

        // Save Button with Loading Indicator
        ElevatedButton(
          onPressed: () {
            // Show loading indicator
            setState(() {
              // Logic to show loading
            });
            _saveChanges();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          child: Text('Save Changes'),
          // Add a loading indicator if needed
        ),
      ],
    );
  }

  Widget _CategoryLimitWidget({
    required String name,
    required IconData icon,
    required double limit,
    required double usedAmount,
    bool available = true,
    bool warning = false,
  }) {
    double progress = (limit > 0) ? (usedAmount / limit).clamp(0.0, 1.0) : 0.0;

    return Opacity(
      opacity: available ? 1 : 0.2,
      child: Container(
        width: 110,
        height: 160,
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.containerColor2,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 4,
              color: Colors.black.withOpacity(.25),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 5,
                backgroundColor:
                    warning ? const Color(0xFFF1C21B) : Colors.grey,
              ),
            ),
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "\$${usedAmount.toStringAsFixed(0)} / \$${limit.toStringAsFixed(0)}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress,
                backgroundColor: Colors.grey[700],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blueAccent.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
