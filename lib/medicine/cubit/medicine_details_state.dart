part of 'medicine_details_cubit.dart';

class MedicineDetailsState {}

class MedicineDetailsInitial extends MedicineDetailsState {}

class MedicineDetailsLoading extends MedicineDetailsState {}

class MedicineDetailsLoaded extends MedicineDetailsState {
  final AppModel? appModel;

  MedicineDetailsLoaded(this.appModel);
}

class MedicineDetailsError extends MedicineDetailsState {}
