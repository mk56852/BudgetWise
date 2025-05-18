// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringTransactionHistoryAdapter
    extends TypeAdapter<RecurringTransactionHistory> {
  @override
  final int typeId = 16;

  @override
  RecurringTransactionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringTransactionHistory(
      isAchieved: fields[0] as bool?,
      date: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringTransactionHistory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isAchieved)
      ..writeByte(1)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringTransactionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
