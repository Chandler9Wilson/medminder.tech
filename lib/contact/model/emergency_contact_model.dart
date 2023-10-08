import 'package:medminder/constants.dart';

class AppModel {
  final String uid;
  final List contacts;
  List medicine;

  AppModel(this.uid, this.contacts, this.medicine);

  Map<String, dynamic> toJson() =>
      {Constants.uid: uid, contactsKey: contacts, medicineKey: medicine};

  static AppModel fromJson(Map<String, dynamic> json) => AppModel(
        json[Constants.uid],
        json[contactsKey],
        json[medicineKey] == null ? null : json['medicine'],
      );
}

class Medicine {
  final String name;
  final String description;
  final List timeStamp;

  const Medicine(this.name, this.description, this.timeStamp);

  Map<String, dynamic> toJson() =>
      {nameKey: name, descriptionKey: description, timeStampKey: timeStamp};

  static Medicine fromJson(Map<String, dynamic> json) =>
      Medicine(json[nameKey], json[descriptionKey], json[timeStampKey]);
}

const String contactsKey = 'contacts';
const String medicineKey = 'medicine';
const String nameKey = 'name';
const String descriptionKey = 'description';
const String timeStampKey = 'timeStamp';
