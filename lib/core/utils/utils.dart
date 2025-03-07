import 'dart:math';
import 'package:budget_wise/data/models/transaction.dart';

// Function to return a list of currencies
List<String> getCurrencyList() {
  return [
    'USD', // US Dollar
    'EUR', // Euro
    'JPY', // Japanese Yen
    'GBP', // British Pound
    'AUD', // Australian Dollar
    'CAD', // Canadian Dollar
    'CHF', // Swiss Franc
    'CNY', // Chinese Yuan
    'SEK', // Swedish Krona
    'NZD', // New Zealand Dollar
  ];
}

String generateId(String header) {
  final random = Random();
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0125';

  // Generate a random alphanumeric string of size 5
  String randomString =
      List.generate(7, (index) => characters[random.nextInt(characters.length)])
          .join();

  // Generate a random number between 100 and 99,999
  int randomNumber = 100 + random.nextInt(99999 - 100 + 1);

  // Combine the header, random string, and random number
  return '$header-$randomString-$randomNumber';
}

String generatePriorityMessage(int priority, int? dayLeft) {
  switch (priority) {
    case 2:
      return "This is a High priority goal. ${generateDayLeftMessage(dayLeft)}";
    case 1:
      return "This is a Medium priority goal. ${generateDayLeftMessage(dayLeft)}";
    default:
      return "This is a Low priority goal. ${generateDayLeftMessage(dayLeft)}";
  }
}

String generateDayLeftMessage(int? dayLeft) {
  if (dayLeft == null) {
    return " Never give up! Success is getting what you want";
  }
  if (dayLeft > 30) {
    return "We still have more than a month to achieve it";
  } else if (dayLeft > 7) {
    return "We still have more than one week to achieve it";
  } else if (dayLeft > 0) {
    return "Need to achieve it as soon as possible";
  } else {
    return "We passed the deadline";
  }
}

int calculatePercentage(double firstValue, double secondValue) {
  if (firstValue + secondValue == 0) {
    return 0; // Avoid division by zero
  }

  double percentage = (firstValue / (firstValue + secondValue)) * 100;
  return percentage.toInt(); // Convert to an integer
}

int monthsBetween(DateTime date, {bool inverse = false}) {
  DateTime now = DateTime.now();

  int yearsDiff = date.year - now.year;
  int monthsDiff = date.month - now.month;

  int result = (yearsDiff * 12) + monthsDiff;

  return inverse ? result.abs() : result;
}

bool isRecurringTransactionDue(Transaction txn) {
  if (!txn.isRecurring) return false;
  DateTime now = DateTime.now();
  // The transaction is due if now is equal or after the scheduled date.
  return now.isAfter(txn.date) || now.isAtSameMomentAs(txn.date);
}
