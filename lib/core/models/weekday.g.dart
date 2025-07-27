// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekday.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeekdayAdapter extends TypeAdapter<Weekday> {
  @override
  final typeId = 3;

  @override
  Weekday read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Weekday.saturday;
      case 1:
        return Weekday.sunday;
      case 2:
        return Weekday.monday;
      case 3:
        return Weekday.tuesday;
      case 4:
        return Weekday.wednesday;
      case 5:
        return Weekday.thursday;
      case 6:
        return Weekday.friday;
      default:
        return Weekday.saturday;
    }
  }

  @override
  void write(BinaryWriter writer, Weekday obj) {
    switch (obj) {
      case Weekday.saturday:
        writer.writeByte(0);
      case Weekday.sunday:
        writer.writeByte(1);
      case Weekday.monday:
        writer.writeByte(2);
      case Weekday.tuesday:
        writer.writeByte(3);
      case Weekday.wednesday:
        writer.writeByte(4);
      case Weekday.thursday:
        writer.writeByte(5);
      case Weekday.friday:
        writer.writeByte(6);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekdayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
