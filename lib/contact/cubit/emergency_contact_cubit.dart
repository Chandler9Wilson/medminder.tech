import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:medminder/constants.dart';
import 'package:medminder/contact/model/emergency_contact_model.dart';
import 'package:medminder/contact/service/emergency_contact_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'emergency_contact_state.dart';

class EmergencyContactCubit extends Cubit<EmergencyContactState> {
  EmergencyContactCubit() : super(EmergencyContactInitial());

  final EmergencyContactService _emergencyContactService =
      EmergencyContactService();

  Future<void> addEmergencyContact(String emergencyContact) async {
    debugPrint(emergencyContact);
    final uid = GetIt.I<SharedPreferences>().getString(Constants.uid);

    await EmergencyContactService()
        .addEmergencyContact(uid!, AppModel(uid, [emergencyContact], []));

    await GetIt.I<SharedPreferences>()
        .setBool("emergencyContactAvailable", true);
  }

  void emitLoadedState() {
    emit(EmergencyContactLoaded());
  }
}
