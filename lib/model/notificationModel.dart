import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String userId;
  String requestUserId;
  bool isAccept;
  int createdAt;
  int updatedAt;
  String docId;

  NotificationModel({
    this.userId,
    this.docId,
    this.requestUserId,
    this.isAccept = false,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  static NotificationModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot != null && snapshot.exists) {
      return NotificationModel(
        docId: snapshot.documentID,
        userId: snapshot.data['userId'],
        requestUserId: snapshot.data['requestUserId'],
        isAccept: snapshot.data['isAccept'],
        updatedAt: snapshot.data['updatedAt'] ?? 0,
        createdAt: snapshot.data['createdAt'] ?? 0,
      );
    }
    return null;
  }

  factory NotificationModel.fromJson(Map json) {
    return NotificationModel(
      userId: json['userId'],
      requestUserId: json['requestUserId'],
      isAccept: json['isAccept'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'requestUserId': requestUserId,
        'isAccept': isAccept,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
