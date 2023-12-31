import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medminder/app_theme.dart';
import 'package:medminder/contact/cubit/emergency_contact_cubit.dart';
import 'package:medminder/main.dart';

class EmergencyContactView extends StatefulWidget {
  const EmergencyContactView({super.key});

  @override
  State<EmergencyContactView> createState() => _EmergencyContactViewState();
}

class _EmergencyContactViewState extends State<EmergencyContactView> {
  Widget space() {
    return const SizedBox(
      height: 10,
    );
  }

  final List<String> selectedDays = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contact'),
      ),
      body: BlocBuilder<EmergencyContactCubit, EmergencyContactState>(
        builder: (context, state) {
          if (state is EmergencyContactLoaded ||
              state is EmergencyContactInitial) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      child: Text(
                        'Add Family Member or Caretaker',
                        style: TextStyle(
                            color: AppColor.appPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    space(),
                    space(),
                    space(),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: "Who's number is this?",
                              labelText: 'Contact Name *',
                              fillColor: AppColor.appPrimaryColor,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColor.appPrimaryColor)),
                            ),
                            controller: _nameController,
                            style: const TextStyle(
                                color: AppColor.appPrimaryColor),
                            keyboardType: TextInputType.name,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.phone),
                              hintText: "(555) 555-1234",
                              labelText: 'Contact Phone Number *',
                              fillColor: AppColor.appPrimaryColor,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColor.appPrimaryColor)),
                            ),
                            controller: _phoneController,
                            style: const TextStyle(
                                color: AppColor.appPrimaryColor),
                            keyboardType: TextInputType.phone,
                          ),
                          space(),
                          space(),
                          TextButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    AppColor.appPrimaryColor)),
                            onPressed: () async {
                              await context
                                  .read<EmergencyContactCubit>()
                                  .addEmergencyContact(_phoneController.text);

                              await goRouter.push('/create-medicine');
                            },
                            child: const Text(
                              'Add',
                              style: TextStyle(color: AppColor.appAccentColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
