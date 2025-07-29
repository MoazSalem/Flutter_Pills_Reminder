import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/domain/datasources/medication_local_data_source.dart';

class MedicationLocalDataSourceImpl implements MedicationLocalDataSource {
  final Box<MedicationModel> box;

  MedicationLocalDataSourceImpl(this.box);

  @override
  Future<List<MedicationModel>> getAll() async {
    return box.values.toList();
  }

  @override
  Future<MedicationModel> get(int id) async {
    final MedicationModel medication = box.get(id)!;
    return medication;
  }

  @override
  Future<void> add(MedicationModel medication) async {
    await box.put(medication.id, medication);
  }

  @override
  Future<void> update(MedicationModel medication) async {
    await box.put(medication.id, medication);
  }

  @override
  Future<void> delete(int id) async {
    await box.delete(id);
  }
}
