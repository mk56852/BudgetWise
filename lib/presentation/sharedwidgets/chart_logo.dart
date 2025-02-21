import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChartLogo extends StatelessWidget {
  final Color color;
  const ChartLogo({super.key, required this.color});

  double getRandom() {
    int max = 30;
    double randomNumber = Random().nextInt(max) + 16;
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Container(
        width: 6,
        height: getRandom(),
        color: color,
      ),
      SizedBox(
        width: 3,
      ),
      Container(
        width: 6,
        height: getRandom(),
        color: color,
      ),
      SizedBox(
        width: 3,
      ),
      Container(
        width: 6,
        height: getRandom(),
        color: color,
      ),
      SizedBox(
        width: 3,
      ),
      Container(
        width: 6,
        height: getRandom(),
        color: color,
      ),
      SizedBox(
        width: 3,
      ),
      Container(
        width: 6,
        height: getRandom(),
        color: color,
      ),
    ];
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(items.length, (index) {
          return Animate(
            effects: [
              FadeEffect(duration: 250.ms),
              SlideEffect(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
                duration: 250.ms,
                curve: Curves.easeOut,
              ),
            ],
            onPlay: (controller) => controller.forward(),
            delay: (100 * index).ms,
            child: items[index],
          );
        }));
  }
}
