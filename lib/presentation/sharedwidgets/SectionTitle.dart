import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final Function? onTab;
  const SectionTitle({super.key, required this.text, this.onTab});

  @override
  Widget build(BuildContext context) {
    if (onTab == null) {
      return Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 20,
          )
        ],
      );
    }
  }
}
