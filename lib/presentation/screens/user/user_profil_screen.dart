import 'package:budget_wise/data/models/settings.dart';
import 'package:budget_wise/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
          userImage =
              "assets/images/drag.png"; // Change this if user has an image
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
        // Avatar at the top center
        SizedBox(
          height: 200,
          width: 200,
          child: Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(userImage!),
              backgroundColor: Colors.grey[800],
            ),
          ),
        ),
        SizedBox(height: 30), // Increased spacing for better layout

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
}
