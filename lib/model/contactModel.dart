import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  List<String> contact;
  List<String> contactUserName;
  List<String> contactUserPhone;

  ContactModel({
    this.contact,
    this.contactUserName,
    this.contactUserPhone,
  });

  static ContactModel parseSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> _contacts = snapshot.data['contact'] ?? [];
    List<dynamic> _contactUserName = snapshot.data['contactUserName'] ?? [];
    List<dynamic> _contactUserPhone = snapshot.data['contactUserPhone'] ?? [];

    if (snapshot != null && snapshot.exists) {
      return ContactModel(
        contact: _contacts.map((id) => id.toString()).toList(),
        contactUserName: _contactUserName.map((id) => id.toString()).toList(),
        contactUserPhone: _contactUserPhone.map((id) => id.toString()).toList(),
      );
    }
    return null;
  }

// Data get
  factory ContactModel.fromJson(Map json) {
    return ContactModel(
      contact: json['contact'],
      contactUserName: json['contactUserName'],
      contactUserPhone: json['contactUserPhone'],
    );
  }

// Data Put //update
  Map<String, dynamic> toJson() => {
        'contact': contact,
        'contactUserName': contactUserName,
        'contactUserPhone': contactUserPhone,
      };
}
