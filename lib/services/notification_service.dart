import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class NotificationService {
  static Future<void> sendNotificationToAll(String message) async {
    final usersRef = FirebaseDatabase.instance.ref("users");
    final snapshot = await usersRef.get();

    List<String> tokens = [];
    for (var child in snapshot.children) {
      final token = child.child("token").value;
      if (token != null) tokens.add(token.toString());
    }

    for (var token in tokens) {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=YOUR_SERVER_KEY"
        },
        body: jsonEncode({
          "to": token,
          "notification": {
            "title": "Peringatan Sistem",
            "body": message,
          }
        }),
      );
    }
  }
}
