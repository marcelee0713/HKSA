import 'dart:convert';

Head headFromJson(String str) => Head.fromJson(json.decode(str));

String headToJson(Head data) => json.encode(data.toJson());

class Head {
  String name;
  String password;
  String userId;
  String profilePicture;
  String listeningTo;

  Head({
    required this.name,
    required this.password,
    required this.userId,
    required this.profilePicture,
    required this.listeningTo,
  });

  factory Head.fromJson(Map<String, dynamic> json) => Head(
        name: json["name"],
        password: json["password"],
        userId: json["userID"],
        profilePicture: json["profilePicture"],
        listeningTo: json["listeningTo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "password": password,
        "userID": userId,
        "profilePicture": profilePicture,
        "listeningTo": listeningTo,
      };
}
