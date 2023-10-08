import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medminder/constants.dart';
import 'package:medminder/contact/model/emergency_contact_model.dart';
import 'package:medminder/contact/service/emergency_contact_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'medicine_details_state.dart';

class MedicineDetailsCubit extends Cubit<MedicineDetailsState> {
  MedicineDetailsCubit() : super(MedicineDetailsInitial());

  Future<AppModel?> getAppModel() async {
    final uid = GetIt.I<SharedPreferences>().getString(Constants.uid);
    final appModel = await EmergencyContactService().getEmergencyContacts(uid!);
    emit(MedicineDetailsLoaded(appModel));
    return null;
  }
}
