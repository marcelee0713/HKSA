import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendNotificationToTopic(
    String topic, String title, String body) async {
  final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAkHJkjVI:APA91bE9Lwk-DuzioZghllznndx3XTujKQGWf2V5YhEL0eoa-KlYE0Gh8Vu1I6LMj7WCiSNnDHItvJ9OXAGEHym1Y3noICxIYncKP6C0DXdRglpDpPrukD0JZwseaT1B9cU8LW-5wChu',
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
  if (response.statusCode == 200) {
    print('Notification sent to topic: $topic');
  } else {
    print('Failed to send notification. Error: ${response.body}');
  }
}
