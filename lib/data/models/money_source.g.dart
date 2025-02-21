// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_source.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoneySourceAdapter extends TypeAdapter<MoneySource> {
  @override
  final int typeId = 2;

  @override
  MoneySource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoneySource(
      id: fields[0] as String,
      name: fields[1] as String,
      amount: fields[2] as double,
      frequency: fields[3] as String,
      nextDueDate: fields[4] as DateTime,
      lastAdded: fields[5] as DateTime,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MoneySource obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.frequency)
      ..writeByte(4)
      ..write(obj.nextDueDate)
      ..writeByte(5)
      ..write(obj.lastAdded)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneySourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
