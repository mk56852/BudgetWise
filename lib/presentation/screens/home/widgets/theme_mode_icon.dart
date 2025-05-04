import 'package:budget_wise/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeIcon extends ConsumerWidget {
  const ThemeModeIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return InkWell(
      onTap: () {
        final currentTheme = ref.read(themeModeProvider.notifier).state;
        ref.read(themeModeProvider.notifier).state =
            currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      },
      child: Container(
        height: 50,
        width: 50,
        child: Hero(
          tag: "setting",
          child: Icon(
            Icons.brightness_6,
            color: theme.iconColorInsideContainer,
            size: 30,
          ),
        ),
      ),
    );
  }
}
