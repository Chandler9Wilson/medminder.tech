import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:medminder/constants.dart';
import 'package:medminder/contact/model/emergency_contact_model.dart';
import 'package:medminder/contact/service/emergency_contact_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'medicine_details_state.dart';

class MedicineDetailsCubit extends Cubit<MedicineDetailsState> {
  MedicineDetailsCubit() : super(MedicineDetailsInitial());

  Future<void> getAppModel() async {
    final uid = GetIt.I<SharedPreferences>().getString(Constants.uid);
    final appModel = await EmergencyContactService().getEmergencyContacts(uid!);

    final days = [];

    if (appModel != null && appModel.medicine != null) {
      appModel.medicine!.forEach((element) {
        final medicine = Medicine.fromJson(element);
        medicine.timeStamp.keys.forEach((day) {
          if (!days.contains(day)) {
            days.add(day);
          }
        });
      });

      final mvdm = <MedicineViewDetailModel>[];

      for (final day in days) {
        final medicineNamesForDay = <String>[];
        final medicineDescForDay = <String>[];
        final checkBoxValue = <bool>[];
        for (final medicine in appModel.medicine!) {
          final medModel = Medicine.fromJson(medicine);
          medicineNamesForDay.addAll(
              medModel.timeStamp.containsKey(day) ? [medModel.name] : []);

          medicineDescForDay.addAll(medModel.timeStamp.containsKey(day)
              ? [medModel.description]
              : []);
          checkBoxValue.addAll(medModel.timeStamp.containsKey(day)
              ? [medModel.timeStamp[day]]
              : []);
        }
        mvdm.add(MedicineViewDetailModel(
            day, medicineNamesForDay, medicineDescForDay, checkBoxValue));
      }
      emit(MedicineDetailsLoaded(mvdm));
      return;
    }

    emit(MedicineDetailsEmpty());
    return;
  }

  Future<void> toggleCheckBox(String dayName, String medicineNam) async {
    emit(MedicineDetailsLoading());
    await EmergencyContactService().toggleCheckBox(medicineNam, dayName);
    emit(MedicineDetailsInitial());
  }

  void emitInitial() {
    emit(MedicineDetailsInitial());
  }
}
