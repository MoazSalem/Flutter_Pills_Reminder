// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final typeId = 5;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      id: (fields[0] as num).toInt(),
      title: fields[1] as String,
      body: fields[2] as String,
      time: fields[3] as tz.TZDateTime,
      matchComponents: fields[4] as DateTimeComponents?,
      androidScheduleMode: fields[5] == null
          ? AndroidScheduleMode.exactAllowWhileIdle
          : fields[5] as AndroidScheduleMode,
      payload: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.matchComponents)
      ..writeByte(5)
      ..write(obj.androidScheduleMode)
      ..writeByte(6)
      ..write(obj.payload);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
