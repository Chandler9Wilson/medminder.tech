import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medminder/app_theme.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:medminder/main.dart';
import 'package:medminder/medicine/cubit/medicine_cubit.dart';
import 'package:medminder/medicine/cubit/medicine_details_cubit.dart';
import 'package:medminder/medicine/widget/display_day_of_week.dart';

class MedicineFormView extends StatefulWidget {
  const MedicineFormView({super.key});

  @override
  State<MedicineFormView> createState() => _MedicineFormViewState();
}

class _MedicineFormViewState extends State<MedicineFormView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _days = <String>[];

  Widget spacer() {
    return const SizedBox(
      height: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Mediciation',
        ),
      ),
      body: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      spacer(),
                      TextFormField(
                        controller: _name,
                        style: const TextStyle(
                          color: AppColor.appPrimaryColor,
                        ),
                        decoration: const InputDecoration(
                          label: Text(
                            'Medicine Name',
                            style: TextStyle(
                              color: AppColor.appPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          fillColor: AppColor.appPrimaryColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.appPrimaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.appPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      spacer(),
                      TextFormField(
                        controller: _description,
                        style: const TextStyle(
                          color: AppColor.appPrimaryColor,
                        ),
                        decoration: const InputDecoration(
                          label: Text(
                            'Dose',
                            style: TextStyle(
                                color: AppColor.appPrimaryColor, fontSize: 16),
                          ),
                          fillColor: AppColor.appPrimaryColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.appPrimaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.appPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      spacer(),
                      spacer(),
                      DaySelectionScreen(
                        selectedDaysCallback: _days,
                      ),
                      spacer(),
                      spacer(),
                      TextButton(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              AppColor.appPrimaryColor),
                        ),
                        onPressed: () async {
                          await context.read<MedicineCubit>().addMedicine(
                                _name.text,
                                _description.text,
                                _days,
                              );
                          GetIt.I<MedicineDetailsCubit>().emitInitial();
                          await goRouter.push('/view-medicine');
                        },
                        child: const SizedBox(
                          height: 30,
                          width: 80,
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColor.appSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
