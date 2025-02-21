import '../data/models/settings.dart';
import '../data/repositories/settings_repository.dart';

class SettingsService {
  final SettingsRepository _settingsRepository;

  SettingsService(this._settingsRepository);

  // Add new settings
  Future<void> addSettings(Settings settings) async {
    await _settingsRepository.addSettings(settings);
  }

  Settings? getSettings() {
    return _settingsRepository.getSettings();
  }

  // Update settings
  Future<void> updateSettings(Settings settings) async {
    await _settingsRepository.updateSettings(settings);
  }
}
