import 'package:flutter/material.dart';

// Custom Dropdown Button Widget
class DropDownFilter extends StatelessWidget {
  final String? selectedValue;
  final List<String> values;
  final ValueChanged<String?> onChanged;
  final IconData icon;
  final String hint;

  const DropDownFilter({
    super.key,
    required this.values,
    required this.selectedValue,
    required this.onChanged,
    required this.icon,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        icon: Icon(icon, color: Colors.white),
        dropdownColor: Colors.black,
        hint: Text(
          hint,
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        isExpanded: true,
        underline: SizedBox(),
        items: values
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    Text(
                      item,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
