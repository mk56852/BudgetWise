import 'package:budget_wise/core/constants/Colors.dart';
import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final double? height;
  final bool fillWidth;
  final Widget child;
  const AppContainer(
      {super.key, required this.child, this.fillWidth = true, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fillWidth ? double.maxFinite : null,
      height: height,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
