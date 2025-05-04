import 'dart:ffi';

import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/theme.dart';
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
      this.height = 55,
      required this.onTab});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTab(),
      child: AppContainer(
        color: Theme.of(context).extension<AppTheme>()!.containerColor3,
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
  final bool insideContainer;
  final Function onTap;
  String? text;
  AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.insideContainer = false,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppTheme appTheme = theme.extension<AppTheme>()!;

    return Column(
      children: [
        InkWell(
          onTap: () => onTap(),
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.25)
                    : insideContainer
                        ? Colors.black.withOpacity(0.25)
                        : AppColors.darkBlueColor,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        text != null
            ? Text(text!,
                style: TextStyle(
                    fontSize: 12, color: insideContainer ? Colors.white : null),
                softWrap: true)
            : SizedBox()
      ],
    );
  }
}
