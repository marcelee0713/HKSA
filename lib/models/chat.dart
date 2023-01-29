import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    required this.name,
    required this.userId,
  });

  String name;
  String userId;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        name: json["name"],
        userId: json["userID"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "userID": userId,
      };
}
