// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 15;

  @override
  NotificationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationType.SavingGoalDeadline;
      case 1:
        return NotificationType.TransactionDeadline;
      case 2:
        return NotificationType.AnalyticFileGeneration;
      default:
        return NotificationType.SavingGoalDeadline;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    switch (obj) {
      case NotificationType.SavingGoalDeadline:
        writer.writeByte(0);
        break;
      case NotificationType.TransactionDeadline:
        writer.writeByte(1);
        break;
      case NotificationType.AnalyticFileGeneration:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
