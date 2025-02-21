import 'package:hive/hive.dart';
import '../models/settings.dart';

class SettingsRepository {
  final Box<Settings> _settingsBox = Hive.box<Settings>('settings');

  Future<void> addSettings(Settings settings) async {
    await _settingsBox.put(settings.id, settings);
  }

  Settings? getSettings() {
    return _settingsBox.getAt(0);
  }

  Future<void> updateSettings(Settings settings) async {
    await _settingsBox.put(settings.id, settings);
  }
}
