// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_frequency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicationFrequencyAdapter extends TypeAdapter<MedicationFrequency> {
  @override
  final typeId = 2;

  @override
  MedicationFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MedicationFrequency.daily;
      case 1:
        return MedicationFrequency.daysPerWeek;
      case 2:
        return MedicationFrequency.once;
      default:
        return MedicationFrequency.daily;
    }
  }

  @override
  void write(BinaryWriter writer, MedicationFrequency obj) {
    switch (obj) {
      case MedicationFrequency.daily:
        writer.writeByte(0);
      case MedicationFrequency.daysPerWeek:
        writer.writeByte(1);
      case MedicationFrequency.once:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
