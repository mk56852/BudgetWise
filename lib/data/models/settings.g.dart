// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 8;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      id: fields[0] as String,
      theme: fields[1] as String,
      notificationsEnabled: fields[2] as bool,
      limitNotificationsEnabled: fields[3] as bool,
      currency: fields[4] as String,
      defaultView: fields[5] as String?,
      backupPath: fields[6] as String?,
      weeklyLimit: fields[7] as double?,
      monthlyLimit: fields[8] as double?,
      weeklyLimitEnabled: fields[9] as bool,
      monthlyLimitEnabled: fields[10] as bool,
      language: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.theme)
      ..writeByte(2)
      ..write(obj.notificationsEnabled)
      ..writeByte(3)
      ..write(obj.limitNotificationsEnabled)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.defaultView)
      ..writeByte(6)
      ..write(obj.backupPath)
      ..writeByte(7)
      ..write(obj.weeklyLimit)
      ..writeByte(8)
      ..write(obj.monthlyLimit)
      ..writeByte(9)
      ..write(obj.weeklyLimitEnabled)
      ..writeByte(10)
      ..write(obj.monthlyLimitEnabled)
      ..writeByte(11)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
