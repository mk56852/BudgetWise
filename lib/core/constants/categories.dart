import 'package:flutter/material.dart';

List<String> AppCategories = [
  "Food & Dining",
  "Transport",
  "Housing",
  "Entertainment",
  "Shopping",
  "Health & Wellness",
  "Travel",
  "Education",
  "Othor"
];

List<String> incomeSources = [
  "Salary",
  "Freelance",
  "Business",
  "Investments",
  "Rental",
  "Interest",
  "Commissions",
  "Othor"
];

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}

List<Category> appCategoriesWithIcons = [
  Category(name: "Food & Dining", icon: Icons.restaurant),
  Category(name: "Transport", icon: Icons.directions_car),
  Category(name: "Housing", icon: Icons.home),
  Category(name: "Entertainment", icon: Icons.movie),
  Category(name: "Shopping", icon: Icons.shopping_cart),
  Category(name: "Health & Wellness", icon: Icons.local_hospital),
  Category(name: "Travel", icon: Icons.flight),
  Category(name: "Education", icon: Icons.school),
  Category(name: "Other", icon: Icons.category),
];
