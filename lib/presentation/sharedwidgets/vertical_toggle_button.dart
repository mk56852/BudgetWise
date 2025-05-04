import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/theme.dart';
import 'package:flutter/material.dart';

class VerticalToggleButton extends StatelessWidget {
  final List<String> items;
  final Function onTap;
  final int selectedIndex;
  const VerticalToggleButton(
      {super.key,
      required this.items,
      required this.onTap,
      required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    AppTheme theme = appTheme.extension<AppTheme>()!;
    Color selectedColor = appTheme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.2)
        : AppColors.darkBlueColor.withOpacity(0.9);
    Color unselectedColor = appTheme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.06)
        : AppColors.darkBlueColor.withOpacity(0.06);
    Color textSelectedColor = Colors.white;
    Color textunselectedColor = appTheme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.8)
        : Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(12.0),
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              color: selectedIndex == index ? selectedColor : unselectedColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              items[index],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: selectedIndex == index
                    ? textSelectedColor
                    : textunselectedColor,
              ),
            ),
          ),
        );
      }),
    );
  }
}
