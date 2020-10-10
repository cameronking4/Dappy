import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  String firstName;
  String lastName;
  List<String> contactUserName;
  List<String> contactUserPhone;
  String email;
  String facebook;
  String instagram;
  String linkedin;
  String phone;
  String photoUrl;
  String snapchat;
  String tiktok;
  String token;
  String userId;
  String venmo;
  String website;
  String twitter;
  String userName;
  int createdAt;
  int updatedAt;
  String countryCode;
  String justPhone;
  List<String> swappedWith;
  List<String> searchUserName;
  List<String> searchPhone;
  List<String> searchUserId;

  ProfileModel({
    this.firstName,
    this.lastName,
    this.contactUserName,
    this.contactUserPhone,
    this.email,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.phone,
    this.photoUrl,
    this.snapchat,
    this.tiktok,
    this.token,
    this.userId,
    this.venmo,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.countryCode,
    this.justPhone,
    this.searchUserName,
    this.searchPhone,
    this.searchUserId,
    this.website,
    this.swappedWith,
    this.twitter,
  });

  static ProfileModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot != null && snapshot.exists) {
      List<dynamic> _contactUserName = snapshot.data['contactUserName'] ?? [];
      List<dynamic> _contactUserPhone = snapshot.data['contactUserPhone'] ?? [];

      List<dynamic> _searchUserName = snapshot.data['searchUserName'] ?? [];
      List<dynamic> _searchPhone = snapshot.data['searchPhone'] ?? [];
      List<dynamic> _searchUserId = snapshot.data['searchUserId'] ?? [];
      List<dynamic> _swappedWith = snapshot.data['swappedWith'] ?? [];

      return ProfileModel(
        userId: snapshot.data['userId'],
        firstName: snapshot.data['firstName'] ?? '',
        userName: snapshot.data['userName'] ?? '',
        lastName: snapshot.data['lastName'] ?? '',
        email: snapshot.data['email'] ?? '',
        facebook: snapshot.data['facebook'] ?? '',
        instagram: snapshot.data['instagram'] ?? '',
        linkedin: snapshot.data['linkedin'] ?? '',
        phone: snapshot.data['phone'] ?? '',
        photoUrl: snapshot.data['photoUrl'] ?? '',
        snapchat: snapshot.data['snapchat'] ?? '',
        tiktok: snapshot.data['tiktok'] ?? '',
        twitter: snapshot.data['twitter'] ?? '',
        website: snapshot.data['website'] ?? '',
        token: snapshot.data['token'] ?? '',
        venmo: snapshot.data['venmo'] ?? '',
        updatedAt: snapshot.data['updatedAt'] ?? 0,
        createdAt: snapshot.data['createdAt'] ?? 0,
        contactUserName: _contactUserName.map((id) => id.toString()).toList(),
        contactUserPhone: _contactUserPhone.map((id) => id.toString()).toList(),
        countryCode: snapshot.data['countryCode'] ?? '',
        justPhone: snapshot.data['justPhone'] ?? '',
        swappedWith: _swappedWith.map((id) => id.toString()).toList(),
        searchUserName: _searchUserName.map((id) => id.toString()).toList(),
        searchPhone: _searchPhone.map((id) => id.toString()).toList(),
        searchUserId: _searchUserId.map((id) => id.toString()).toList(),
      );
    }
    return null;
  }

  factory ProfileModel.fromJson(Map json) {
    return ProfileModel(
      contactUserName: json['contactUserName'],
      contactUserPhone: json['contactUserPhone'],
      userId: json['userId'],
      firstName: json['firstName'],
      userName: json['userName'],
      lastName: json['lastName'],
      email: json['email'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      linkedin: json['linkedin'],
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      snapchat: json['snapchat'],
      tiktok: json['tiktok'],
      website: json['website'],
      twitter: json['twitter'],
      token: json['token'],
      venmo: json['venmo'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      countryCode: json['countryCode'],
      justPhone: json['justPhone'],
      searchUserName: json['searchUserName'],
      searchPhone: json['searchPhone'],
      searchUserId: json['searchUserId'],
      swappedWith: json['swappedWith'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'email': email,
        'facebook': facebook,
        'instagram': instagram,
        'linkedin': linkedin,
        'phone': phone,
        'photoUrl': photoUrl,
        'snapchat': snapchat,
        'tiktok': tiktok,
        'website': website,
        'twitter': twitter,
        'swappedWith': swappedWith,
        'token': token,
        'venmo': venmo,
        'contactUserName': contactUserName,
        'contactUserPhone': contactUserPhone,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'countryCode': countryCode,
        'justPhone': justPhone,
        'searchUserName': searchUserName,
        'searchPhone': searchPhone,
        'searchUserId': searchUserId,
      };
}
