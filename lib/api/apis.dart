import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class Apis {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void test() {
    firebaseMessaging.requestPermission();
    firebaseMessaging.getToken();
  }
  static Future<void> sendPushNotification(String userName, String message) async {
    try {
      final body = {
        "to": "/topics/chat",
        "notification": {"title": userName, "body": message}
      };
      var response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=YOUR_API_KEY'
              },
              body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('API notification error: $e');
    }
  }
}
