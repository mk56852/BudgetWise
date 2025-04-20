import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final double amount;
  final double? width;
  final double? height;
  const CategoryWidget({
    super.key,
    required this.name,
    this.width,
    this.height,
    required this.icon,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              radius: 5,
              backgroundColor: Colors.red,
            ),
          ),
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${amount.toStringAsFixed(0)} " +
                AppServices.userService.getCurrentUser()!.currency,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
