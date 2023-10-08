import 'package:bloc/bloc.dart';
import 'package:medminder/contact/service/emergency_contact_service.dart';
import 'package:meta/meta.dart';

part 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(MedicineInitial());

  Future<void> addMedicine(
      String name, String doseDesc, List<String> timing) async {
    await EmergencyContactService().addMedicalRecord(name, doseDesc, timing);
  }
}
