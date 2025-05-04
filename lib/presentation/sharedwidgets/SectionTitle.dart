import 'package:budget_wise/core/constants/theme.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final Function? onTab;
  const SectionTitle({super.key, required this.text, this.onTab});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).extension<AppTheme>()!.textColor;
    if (onTab == null) {
      return Text(
        text,
        style:
            TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                color: color, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: color,
            size: 20,
          )
        ],
      );
    }
  }
}
