import 'package:budget_wise/presentation/sharedwidgets/app_container.dart';
import 'package:flutter/material.dart';

class AppActionButton extends StatelessWidget {
  final double height;
  final String text;
  final IconData icon;
  final Function onTab;
  const AppActionButton(
      {super.key,
      required this.text,
      required this.icon,
      this.height = 60,
      required this.onTab});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTab(),
      child: AppContainer(
        height: height,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onTap;
  final String text;
  const AppIconButton(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.text,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTap(),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              icon,
              color: color,
              size: 25,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(text,
            style: TextStyle(fontSize: 12, color: Colors.white), softWrap: true)
      ],
    );
  }
}
