import 'package:budget_wise/core/constants/Colors.dart';
import 'package:flutter/material.dart';

class AppToggleButton extends StatefulWidget {
  final List<String> items;
  final Function(String) onSelected;
  final String? defaultSelected;
  final bool equalSize;
  final double? spacing;

  const AppToggleButton({
    Key? key,
    required this.items,
    required this.onSelected,
    this.defaultSelected,
    this.equalSize = false,
    this.spacing,
  }) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<AppToggleButton> {
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.defaultSelected ?? widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max, // Ensure it takes full width
      children: widget.items.map((item) {
        final isSelected = item == selectedItem;
        final button = GestureDetector(
          onTap: () {
            setState(() {
              selectedItem = item;
            });
            widget.onSelected(item);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : AppColors.containerColor2,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
            ),
            alignment: Alignment.center,
            child: Text(
              item,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

        return widget.equalSize
            ? Expanded(child: button) // Ensures equal width distribution
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.spacing ?? 4),
                child: button,
              );
      }).toList(),
    );
  }
}
