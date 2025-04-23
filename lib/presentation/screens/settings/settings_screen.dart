import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 10,
      ),
      InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
      SizedBox(
        height: 10,
      ),
      Center(
        child: Container(
          height: 80,
          width: 80,
          child: Hero(
            tag: "setting",
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
      ),
      Center(
        child: Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      SizedBox(
        height: 35,
      )
    ]));
  }
}
