import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String userId;
  String requestUserId;
  bool isAccept;
  bool declined;
  int createdAt;
  int updatedAt;
  String docId;

  NotificationModel({
    this.userId,
    this.docId,
    this.declined = false,
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
        declined: snapshot.data['declined'],
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
      declined: json['declined'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'requestUserId': requestUserId,
        'isAccept': isAccept,
        'declined': declined,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
