class PlayLoadNotification {
  Notification notification;
  // NotificationData data;

  PlayLoadNotification({
    this.notification,
    // this.data,
  });

  factory PlayLoadNotification.fromJson(Map json) {
    return PlayLoadNotification(
      notification: json['notification'] == null
          ? null
          : Notification.fromJson(json['notification']),
      // data: json['data'] == null ? null : NotificationData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'notification': notification.toJson(),
        // 'data': data.toJson(),
      };
}

class Notification {
  String title;
  String body;

  Notification({
    this.title = '',
    this.body = '',
  });

  factory Notification.fromJson(Map json) {
    return Notification(
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
      };
}
