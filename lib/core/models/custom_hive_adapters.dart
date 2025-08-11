import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

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

class TZDateTimeAdapter extends TypeAdapter<tz.TZDateTime> {
  @override
  final typeId = 8;

  @override
  tz.TZDateTime read(BinaryReader reader) {
    // Read stored DateTime and timezone name
    final millis = reader.readInt();
    final locationName = reader.readString();

    final location = tz.getLocation(locationName);
    return tz.TZDateTime.fromMillisecondsSinceEpoch(location, millis);
  }

  @override
  void write(BinaryWriter writer, tz.TZDateTime obj) {
    // Store milliseconds and timezone name
    writer.writeInt(obj.millisecondsSinceEpoch);
    writer.writeString(obj.location.name);
  }
}
