// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyticsAdapter extends TypeAdapter<Analytics> {
  @override
  final int typeId = 7;

  @override
  Analytics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Analytics(
      id: fields[0] as String,
      month: fields[1] as int,
      year: fields[2] as int,
      incomeTotal: fields[3] as double,
      expenseTotal: fields[4] as double,
      totalBudget: fields[5] as double,
      savedForGoal: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Analytics obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.incomeTotal)
      ..writeByte(4)
      ..write(obj.expenseTotal)
      ..writeByte(5)
      ..write(obj.totalBudget)
      ..writeByte(6)
      ..write(obj.savedForGoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
