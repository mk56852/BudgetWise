import 'package:hive/hive.dart';
part 'settings.g.dart';

@HiveType(typeId: 8)
class Settings {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String theme;

  @HiveField(2)
  bool notificationsEnabled;

  @HiveField(3)
  bool limitNotificationsEnabled;

  @HiveField(4)
  String currency;

  @HiveField(5)
  String? defaultView;

  @HiveField(6)
  String? backupPath;

  @HiveField(7)
  double? weeklyLimit;

  @HiveField(8)
  double? monthlyLimit;

  @HiveField(9)
  bool weeklyLimitEnabled;

  @HiveField(10)
  bool monthlyLimitEnabled;

  @HiveField(11)
  String? language;

  Settings({
    required this.id,
    required this.theme,
    required this.notificationsEnabled,
    required this.limitNotificationsEnabled,
    required this.currency,
    this.defaultView,
    this.backupPath,
    this.weeklyLimit,
    this.monthlyLimit,
    required this.weeklyLimitEnabled,
    required this.monthlyLimitEnabled,
    this.language,
  });
}
