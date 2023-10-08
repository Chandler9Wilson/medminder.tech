import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: BlocBuilder<EmergencyContactCubit, EmergencyContactState>(
        builder: (context, state) {
          if (state is EmergencyContactLoaded ||
              state is EmergencyContactInitial) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    child: Text(
                      'Add Emergency Contact',
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
                          controller: _textController,
                          style:
                              const TextStyle(color: AppColor.appPrimaryColor),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            fillColor: AppColor.appPrimaryColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColor.appPrimaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.appPrimaryColor,
                              ),
                            ),
                          ),
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
                                .addEmergencyContact(_textController.text);

                            // goRouter.push('/');
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
            );
          }
          return Container();
        },
      ),
    );
  }
}