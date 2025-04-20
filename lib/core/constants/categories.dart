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

Map<String, IconData> AppCategoriesIcon = {
  "Food & Dining": Icons.restaurant,
  "Transport": Icons.directions_car,
  "Housing": Icons.home,
  "Entertainment": Icons.movie_creation,
  "Shopping": Icons.shopping_cart,
  "Health & Wellness": Icons.local_hospital,
  "Travel": Icons.flight,
  "Education": Icons.school,
  "Othor": Icons.help_outline
};

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

Map<String, IconData> incomeSourcesIcon = {
  "Salary": Icons.monetization_on,
  "Freelance": Icons.work_outline,
  "Business": Icons.business_center,
  "Investments": Icons.show_chart,
  "Rental": Icons.home_work,
  "Interest": Icons.attach_money,
  "Commissions": Icons.card_giftcard,
  "Othor": Icons.help_outline,
};

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
