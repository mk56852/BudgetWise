import 'package:budget_wise/core/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  final Color mainContainerColor;
  final Color containerColor;
  final Color containerColor2;
  final Color containerColor3;
  final Color textColor;
  final Color textColorInsideContainer;
  final Color secondTextColor;
  final Color bottomBarColor;
  final Color iconColor;
  final Color iconColorInsideContainer;

  const AppTheme(
      {required this.mainContainerColor,
      required this.containerColor,
      required this.containerColor2,
      required this.containerColor3,
      required this.textColor,
      required this.bottomBarColor,
      required this.secondTextColor,
      required this.iconColor,
      required this.textColorInsideContainer,
      required this.iconColorInsideContainer});

  @override
  AppTheme copyWith(
      {Color? mainContainerColor,
      Color? containerColor,
      Color? containerColor2,
      Color? containerColor3,
      Color? textColor,
      Color? bottomBarColor,
      Color? secondTextColor,
      Color? iconColor,
      Color? iconColorInsideContainer,
      Color? textColorInsideContainer}) {
    return AppTheme(
        mainContainerColor: mainContainerColor ?? this.mainContainerColor,
        containerColor: containerColor ?? this.containerColor,
        containerColor2: containerColor2 ?? this.containerColor2,
        containerColor3: containerColor3 ?? this.containerColor3,
        textColor: textColor ?? this.textColor,
        bottomBarColor: bottomBarColor ?? this.bottomBarColor,
        secondTextColor: secondTextColor ?? this.secondTextColor,
        iconColor: iconColor ?? this.iconColor,
        textColorInsideContainer:
            textColorInsideContainer ?? this.textColorInsideContainer,
        iconColorInsideContainer:
            iconColorInsideContainer ?? this.iconColorInsideContainer);
  }

  @override
  AppTheme lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) return this;
    return AppTheme(
      mainContainerColor:
          Color.lerp(mainContainerColor, other.mainContainerColor, t)!,
      containerColor: Color.lerp(containerColor, other.containerColor, t)!,
      containerColor2: Color.lerp(containerColor2, other.containerColor2, t)!,
      containerColor3: Color.lerp(containerColor3, other.containerColor3, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      secondTextColor: Color.lerp(secondTextColor, other.secondTextColor, t)!,
      bottomBarColor: Color.lerp(bottomBarColor, other.bottomBarColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      textColorInsideContainer:
          Color.lerp(textColorInsideContainer, other.iconColor, t)!,
      iconColorInsideContainer: Color.lerp(
          iconColorInsideContainer, other.iconColorInsideContainer, t)!,
    );
  }
}

ThemeData AppDarkTheme = ThemeData(brightness: Brightness.dark, extensions: [
  AppTheme(
      mainContainerColor: AppColors.darkBlueColor,
      containerColor: AppColors.containerColor,
      containerColor2: AppColors.containerColor2,
      containerColor3: AppColors.containerColor,
      textColor: AppColors.mainTextColor,
      textColorInsideContainer: AppColors.mainTextColor,
      secondTextColor: Colors.grey,
      bottomBarColor: Colors.black,
      iconColor: Colors.white,
      iconColorInsideContainer: Colors.white),
]);

ThemeData AppLightTheme = ThemeData(brightness: Brightness.light, extensions: [
  AppTheme(
      mainContainerColor: Colors.white,
      containerColor: AppColors.darkBlueColor.withOpacity(0.04),
      containerColor2: AppColors.darkBlueColor.withOpacity(0.18),
      containerColor3: AppColors.blueColor,
      textColor: Colors.black,
      textColorInsideContainer: Colors.white,
      secondTextColor: const Color.fromARGB(255, 76, 76, 76),
      bottomBarColor: Colors.white,
      iconColor: Colors.black,
      iconColorInsideContainer: Colors.white),
]);

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light; // Default to light mode
});
