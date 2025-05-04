import 'package:flutter/material.dart';

class TipWidget extends StatelessWidget {
  final String message;
  final Color iconColor;
  const TipWidget({super.key, required this.message, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.priority_high,
          color: iconColor,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
