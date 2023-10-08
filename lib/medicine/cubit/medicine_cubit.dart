import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:medminder/contact/service/emergency_contact_service.dart';
import 'package:meta/meta.dart';

part 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(MedicineInitial());

  Future<void> addMedicine(
      String name, String doseDesc, List<String> timing) async {
    await EmergencyContactService().addMedicalRecord(name, doseDesc, timing);
    final phoneNumbers = await EmergencyContactService().getEmergencyContacts();
    final contactPhone = phoneNumbers!.contacts.first;
    if (timing.contains('Sunday')) {
      await TwilioService().sendOtp(contactPhone, name);
      // await Future.delayed(
      //   const Duration(seconds: 4),
      //   () async {
      //     await TwilioService().sendOtp(contactPhone, name);
      //   },
      // );
    }
  }
}

class TwilioService {
  Future<void> sendOtp(String mobileNumber, String medicineName) async {
    var clientToken = 'AC1f510a0c118eb6ab0701261e7827e108';
    var password = '1d56ff6a1945f6edc2251ae46b112c05';
    var authenticationHeader =
        'Basic ' + base64Encode(utf8.encode('$clientToken:$password'));

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': authenticationHeader
    };

    var data = {
      'TO': '+1$mobileNumber',
      'From': '+18442324983',
      'Body': 'Check on your loved ones medication, $medicineName not taken'
    };

    var url = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/AC1f510a0c118eb6ab0701261e7827e108/Messages.json');

    var res = await http.post(url, headers: headers, body: data);
  }
}
