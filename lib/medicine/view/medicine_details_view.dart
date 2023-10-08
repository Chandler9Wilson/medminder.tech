import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medminder/app_theme.dart';
import 'package:medminder/contact/model/emergency_contact_model.dart';
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
      appBar: AppBar(
        title: const Text('Your Schedule'),
      ),
      body: Center(
        child: BlocBuilder<MedicineDetailsCubit, MedicineDetailsState>(
          builder: (context, state) {
            if (state is MedicineDetailsInitial) {
              context.read<MedicineDetailsCubit>().getAppModel();
              return const CircularProgressIndicator();
            } else if (state is MedicineDetailsLoaded) {
              if (state.appModel != null) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final currentMedicine =
                            Medicine.fromJson(state.appModel!.medicine[index]);
                        return SizedBox(
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              style: ListTileStyle.drawer,
                              tileColor: AppColor.appSecondaryColor,
                              title: Text(
                                currentMedicine.name,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColor.appPrimaryColor),
                              ),
                              subtitle: Text(
                                currentMedicine.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColor.appPrimaryColor,
                                ),
                              ),
                              leading: const FaIcon(FontAwesomeIcons.pills,
                                  color: AppColor.appPrimaryColor),
                              // trailing: Text(currentMedicine.timeStamp),
                            ),
                          ),
                        );
                      },
                      itemCount: state.appModel!.medicine.length,
                    )
                  ]),
                );
              }
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
