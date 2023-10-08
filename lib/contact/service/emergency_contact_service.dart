import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:medminder/constants.dart';
import 'package:medminder/contact/model/emergency_contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyContactService {
  Future<void> addEmergencyContact(
      String uid, AppModel emergencyContactModel) async {
    assert(uid.isNotEmpty);
    final userCollection = FirebaseFirestore.instance.collection(
      GetIt.I<SharedPreferences>().getString(Constants.uid)!,
    );

    final userDocument = await userCollection.get();

    if (userDocument.docs.isNotEmpty) {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        final documentId = userDocument.docs.first;
        final appModel = AppModel.fromJson(documentId.data());
        appModel.contacts.addAll(emergencyContactModel.contacts);
        await userCollection.doc(documentId.id).update(appModel.toJson());
      });
    } else {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await userCollection.add(emergencyContactModel.toJson());
      });
    }
  }

  Future<AppModel?> getEmergencyContacts(String uid) async {
    assert(uid.isNotEmpty);

    final userCollection = FirebaseFirestore.instance
        .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);

    final userDocument = await userCollection.get();

    if (userDocument.docs.isEmpty) {
      return null;
    } else {
      return AppModel.fromJson(userDocument.docs.first.data());
    }
  }

  Future<bool> toggleCheckBox(String medicineName, String day) async {
    final uid = GetIt.I<SharedPreferences>().getString(Constants.uid);
    final userCollection = FirebaseFirestore.instance.collection(uid!);

    final userDocument = await userCollection.get();

    if (userDocument.docs.isNotEmpty) {
      final appModel = AppModel.fromJson(userDocument.docs.first.data());
      final medicine =
          appModel.medicine!.map((e) => Medicine.fromJson(e)).toList();

      medicine
          .firstWhere((element) => element.name == medicineName)
          .timeStamp
          .update(
              day,
              (value) =>
                  value.toString().toLowerCase() == 'true' ? false : true);

      appModel.medicine = medicine.map((e) => e.toJson()).toList();

      await userCollection
          .doc(userDocument.docs.first.id)
          .update(appModel.toJson());
    }

    return true;
  }

  Future<void> addMedicalRecord(
      String name, doseDescription, List<String> dayOfWeeks) async {
    final uid = GetIt.I<SharedPreferences>().getString(Constants.uid);
    final userCollection = FirebaseFirestore.instance.collection(uid!);

    final userDocument = await userCollection.get();

    final map = {};
    for (var key in dayOfWeeks) {
      map.putIfAbsent(key, () => false);
    }

    if (userDocument.docs.isEmpty) {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await userCollection.add(
          AppModel(
            uid,
            [],
            [Medicine(name, doseDescription, map)],
          ).toJson(),
        );
      });
    } else {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        final documentId = userDocument.docs.first;
        final appModel = AppModel.fromJson(documentId.data());
        if (appModel.medicine != null) {
          appModel.medicine!.add(Medicine(name, doseDescription, map).toJson());
        } else {
          appModel.medicine = [Medicine(name, doseDescription, map).toJson()];
        }

        final json = appModel.toJson();
        await userCollection.doc(documentId.id).update(json);
      });
    }
  }
}
