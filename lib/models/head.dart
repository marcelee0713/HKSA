import 'dart:convert';

Head headFromJson(String str) => Head.fromJson(json.decode(str));

String headToJson(Head data) => json.encode(data.toJson());

class Head {
  Head({
    required this.name,
    required this.password,
    required this.userId,
  });

  String name;
  String password;
  String userId;

  factory Head.fromJson(Map<String, dynamic> json) => Head(
        name: json["name"],
        password: json["password"],
        userId: json["userID"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "password": password,
        "userID": userId,
      };
}
