import 'package:budget_wise/core/constants/theme.dart';
import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final double? height;
  final bool fillWidth;
  final Widget child;
  final Color? color;
  const AppContainer(
      {super.key,
      required this.child,
      this.fillWidth = true,
      this.height,
      this.color});

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    if (appTheme.brightness == Brightness.dark)
      return Container(
        width: fillWidth ? double.maxFinite : null,
        height: height,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color == null ? theme.containerColor : color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      );
    else
      return Container(
        width: fillWidth ? double.maxFinite : null,
        height: height,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color == null ? theme.containerColor : color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      );
  }
}
