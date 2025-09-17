import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

part 'notification_model.g.dart';

@HiveType(typeId: 5)
class NotificationList extends HiveObject {
  @HiveField(0)
  List<NotificationModel> items;

  NotificationList({required this.items});
}

@HiveType(typeId: 9)
class NotificationModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  tz.TZDateTime time;

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

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    tz.TZDateTime? time,
    DateTimeComponents? matchComponents,
    AndroidScheduleMode? androidScheduleMode,
    String? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      matchComponents: matchComponents ?? this.matchComponents,
      androidScheduleMode: androidScheduleMode ?? this.androidScheduleMode,
      payload: payload ?? this.payload,
    );
  }
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
