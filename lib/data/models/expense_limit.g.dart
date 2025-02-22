// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_limit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseLimitAdapter extends TypeAdapter<ExpenseLimit> {
  @override
  final int typeId = 13;

  @override
  ExpenseLimit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseLimit(
      categoryName: fields[0] as String,
      limit: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseLimit obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.categoryName)
      ..writeByte(1)
      ..write(obj.limit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseLimitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
