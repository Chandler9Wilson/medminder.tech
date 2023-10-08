part of 'medicine_details_cubit.dart';

class MedicineDetailsState {}

class MedicineDetailsInitial extends MedicineDetailsState {}

class MedicineDetailsLoading extends MedicineDetailsState {}

class MedicineDetailsLoaded extends MedicineDetailsState {
  final List<MedicineViewDetailModel>? viewDetailModel;

  MedicineDetailsLoaded(this.viewDetailModel);
}

class MedicineDetailsEmpty extends MedicineDetailsState {}

class MedicineDetailsError extends MedicineDetailsState {}

class MedicineViewDetailModel {
  final String dayName;
  final List<String> medicineNames;
  final List<String> desc;
  final List<bool> checkBoxValue;

  MedicineViewDetailModel(
      this.dayName, this.medicineNames, this.desc, this.checkBoxValue);
}
