import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'medicine_details_state.dart';

class MedicineDetailsCubit extends Cubit<MedicineDetailsState> {
  MedicineDetailsCubit() : super(MedicineDetailsInitial());
}
