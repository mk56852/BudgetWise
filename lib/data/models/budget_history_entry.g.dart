// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_history_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetHistoryEntryAdapter extends TypeAdapter<BudgetHistoryEntry> {
  @override
  final int typeId = 11;

  @override
  BudgetHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetHistoryEntry(
      amount: fields[0] as double,
      updatedAt: fields[1] as DateTime,
      transactionId: fields[2] as String?,
      lastAmount: fields[4] as double,
      isForSavings: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetHistoryEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.updatedAt)
      ..writeByte(2)
      ..write(obj.transactionId)
      ..writeByte(3)
      ..write(obj.isForSavings)
      ..writeByte(4)
      ..write(obj.lastAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetHistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
