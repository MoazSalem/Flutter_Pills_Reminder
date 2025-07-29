// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_model_adapter.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class MedicationModelAdapter extends TypeAdapter<MedicationModel> {
  @override
  final typeId = 0;

  @override
  MedicationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicationModel(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      amount: (fields[2] as num?)?.toInt(),
      times: (fields[4] as List).cast<TimeOfDay>(),
      timesPillTaken: (fields[7] as List).cast<bool>(),
      frequency: fields[3] as MedicationFrequency,
      selectedDays: (fields[5] as List?)?.cast<Weekday>(),
      monthlyDay: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicationModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.frequency)
      ..writeByte(4)
      ..write(obj.times)
      ..writeByte(5)
      ..write(obj.selectedDays)
      ..writeByte(6)
      ..write(obj.monthlyDay)
      ..writeByte(7)
      ..write(obj.timesPillTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
