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

        await userCollection
            .doc(documentId.id)
            .update(emergencyContactModel.toJson());
      });
    } else {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await userCollection.add(emergencyContactModel.toJson());
      });
    }
  }

  Future<List<String>> getEmergencyContacts(String uid) async {
    assert(uid.isNotEmpty);

    final userCollection = FirebaseFirestore.instance
        .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);

    final userDocument = await userCollection.get();

    if (userDocument.docs.isEmpty) {
      return [];
    } else {
      return AppModel.fromJson(userDocument.docs.first.data()).contacts;
    }
  }
}
