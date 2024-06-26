import 'dart:convert';

Head headFromJson(String str) => Head.fromJson(json.decode(str));

String headToJson(Head data) => json.encode(data.toJson());

class Head {
  String name;
  String userId;
  String profilePicture;
  String listeningTo;
  String isEmailVerified;
  String isPhoneVerified;
  String isSuperAdmin;
  String phonenumber;
  String status;
  String email;

  Head({
    required this.name,
    required this.userId,
    required this.profilePicture,
    required this.listeningTo,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isSuperAdmin,
    required this.phonenumber,
    required this.status,
    required this.email,
  });

  factory Head.fromJson(Map<String, dynamic> json) => Head(
        name: json["name"],
        userId: json["userID"],
        profilePicture: json["profilePicture"],
        listeningTo: json["listeningTo"],
        isEmailVerified: json["isEmailVerified"],
        isPhoneVerified: json["isPhoneVerified"],
        isSuperAdmin: json["isSuperAdmin"],
        phonenumber: json["phonenumber"],
        status: json["status"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "userID": userId,
        "profilePicture": profilePicture,
        "listeningTo": listeningTo,
        "isEmailVerified": isEmailVerified,
        "isPhoneVerified": isPhoneVerified,
        "isSuperAdmin": isSuperAdmin,
        "phonenumber": phonenumber,
        "status": status,
        "email": email,
      };
}
