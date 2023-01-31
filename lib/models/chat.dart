import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    required this.name,
    required this.userId,
    required this.pfp,
  });

  String name;
  String userId;
  String pfp;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        name: json["name"],
        userId: json["userId"],
        pfp: json["pfp"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "userId": userId,
        "pfp": pfp,
      };
}
