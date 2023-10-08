import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medminder/app_theme.dart';
import 'package:medminder/main.dart';
import 'package:medminder/medicine/cubit/medicine_details_cubit.dart';

class MedicineDetailsView extends StatefulWidget {
  const MedicineDetailsView({super.key});

  @override
  State<MedicineDetailsView> createState() => _MedicineDetailsViewState();
}

class _MedicineDetailsViewState extends State<MedicineDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FloatingActionButton(
          backgroundColor: AppColor.appSecondaryColor,
          child: const Icon(Icons.add),
          onPressed: () async {
            await goRouter.push('/create-medicine');
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text('My Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: BlocBuilder<MedicineDetailsCubit, MedicineDetailsState>(
          builder: (context, state) {
            if (state is MedicineDetailsInitial) {
              context.read<MedicineDetailsCubit>().getAppModel();
              return const CircularProgressIndicator();
            } else if (state is MedicineDetailsLoaded) {
              return SingleChildScrollView(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      backgroundColor: AppColor.appSecondaryColor,
                      iconColor: AppColor.appPrimaryColor,
                      trailing: const Icon(
                        Icons.expand_more,
                        color: AppColor.appPrimaryColor,
                      ),
                      title: Text(
                        state.viewDetailModel![index].dayName,
                        style: const TextStyle(color: AppColor.appPrimaryColor),
                      ),
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, id) {
                            final currentDayModel =
                                state.viewDetailModel![index];
                            return ListTile(
                              leading: const FaIcon(
                                FontAwesomeIcons.pills,
                                color: AppColor.appPrimaryColor,
                              ),
                              title: Text(
                                currentDayModel.medicineNames[id],
                                style: const TextStyle(
                                  color: AppColor.appPrimaryColor,
                                ),
                              ),
                              subtitle: Text(
                                currentDayModel.desc[id],
                                style: const TextStyle(
                                  color: AppColor.appPrimaryColor,
                                ),
                              ),
                              trailing: Checkbox(
                                focusColor: AppColor.appPrimaryColor,
                                value: currentDayModel.checkBoxValue[id],
                                onChanged: (bool? value) async {
                                  await context
                                      .read<MedicineDetailsCubit>()
                                      .toggleCheckBox(currentDayModel.dayName,
                                          currentDayModel.medicineNames[id]);
                                },
                              ),
                            );
                          },
                          itemCount: state
                              .viewDetailModel![index].medicineNames.length,
                        )
                      ],
                    );
                  },
                  itemCount: state.viewDetailModel!.length,
                ),
              );
            } else if (state is MedicineDetailsError) {
              return Row(
                children: const [
                  Icon(Icons.error_outline),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Something went wrong!')
                ],
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
