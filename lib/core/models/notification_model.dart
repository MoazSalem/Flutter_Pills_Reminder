import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 5)
class NotificationModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  TZDateTime time;

  @HiveField(4)
  DateTimeComponents? matchComponents;

  @HiveField(5)
  AndroidScheduleMode androidScheduleMode;

  @HiveField(6)
  String? payload;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.matchComponents,
    this.androidScheduleMode = AndroidScheduleMode.exactAllowWhileIdle,
    this.payload,
  });
}

class DateTimeComponentsAdapter extends TypeAdapter<DateTimeComponents> {
  @override
  final typeId = 6;

  @override
  DateTimeComponents read(BinaryReader reader) {
    return DateTimeComponents.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, DateTimeComponents obj) {
    writer.writeInt(obj.index);
  }
}

class AndroidScheduleModeAdapter extends TypeAdapter<AndroidScheduleMode> {
  @override
  final typeId = 7;

  @override
  AndroidScheduleMode read(BinaryReader reader) {
    return AndroidScheduleMode.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, AndroidScheduleMode obj) {
    writer.writeInt(obj.index);
  }
}
