import 'package:hive_ce/hive.dart';
import 'package:pills_reminder/features/main_screen/data/models/medication_model.dart';
import 'package:pills_reminder/features/main_screen/domain/datasources/medication_local_data_source.dart';

class MedicationLocalDataSourceImpl implements MedicationLocalDataSource {
  final Box<MedicationModel> box;

  MedicationLocalDataSourceImpl(this.box);

  @override
  Future<List<MedicationModel>> getAll() async {
    return box.values.toList();
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
  Future<void> delete(String id) async {
    await box.delete(id);
  }
}
