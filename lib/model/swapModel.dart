import 'package:cloud_firestore/cloud_firestore.dart';

class SwapModel {
  String userId;
  String swapuserId;
  String locationAddreess;
  int createdAt;
  int updatedAt;
  bool isDismiss;
  bool isScannerUser;

  SwapModel({
    this.userId,
    this.swapuserId,
    this.locationAddreess,
    this.createdAt = 0,
    this.updatedAt = 0,
    this.isDismiss = false,
    this.isScannerUser = true,
  });

  static SwapModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot != null && snapshot.exists) {
      return SwapModel(
        userId: snapshot.data['userId'],
        swapuserId: snapshot.data['swapuserId'],
        locationAddreess: snapshot.data['locationAddreess'],
        updatedAt: snapshot.data['updatedAt'] ?? 0,
        createdAt: snapshot.data['createdAt'] ?? 0,
        isDismiss: snapshot.data['isDismiss'] ?? false,
        isScannerUser: snapshot.data['isScannerUser'] ?? true,
      );
    }
    return null;
  }

  factory SwapModel.fromJson(Map json) {
    return SwapModel(
      userId: json['userId'],
      swapuserId: json['swapuserId'],
      locationAddreess: json['locationAddreess'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      isDismiss: json['isDismiss'],
      isScannerUser: json['isScannerUser'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'swapuserId': swapuserId,
        'createdAt': createdAt,
        'locationAddreess': locationAddreess,
        'updatedAt': updatedAt,
        'isDismiss': isDismiss,
        'isScannerUser': isScannerUser,
      };
}
