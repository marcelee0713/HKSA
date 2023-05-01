import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  String name;
  String userId;
  String pfp;
  String userType;
  String isIncomplete;

  Chat({
    required this.name,
    required this.userId,
    required this.pfp,
    required this.userType,
    required this.isIncomplete,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        name: json["name"],
        userId: json["userId"],
        pfp: json["pfp"],
        userType: json["userType"],
        isIncomplete: json["isIncomplete"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "userId": userId,
        "pfp": pfp,
        "userType": userType,
        "isIncomplete": isIncomplete,
      };
}
