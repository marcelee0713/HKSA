import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendNotificationToTopic(
    String topic, String title, String body) async {
  try {
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=getyourownserverkeyinfirebase_:P',
    };
    final bodyJson = jsonEncode(<String, dynamic>{
      'to': '/topics/$topic',
      'notification': <String, dynamic>{
        'title': title,
        'body': body,
        'sound': 'default',
        'badge': '1',
      },
      'priority': 'high',
    });
    final response = await http.post(url, headers: headers, body: bodyJson);
    if (response.statusCode != 200) {
      throw "Error failed to send announcement!";
    }
  } catch (e) {
    throw e.toString();
  }
}
