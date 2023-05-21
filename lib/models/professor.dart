import 'dart:convert';

Professor professorFromJson(String str) => Professor.fromJson(json.decode(str));

String professorToJson(Professor data) => json.encode(data.toJson());

class Professor {
  String department;
  String email;
  String name;
  String password;
  String phonenumber;
  String professorId;
  String signaturecode;
  String profilePicture;
  String section;
  String subject;
  String day;
  String time;
  String room;
  String listeningTo;
  String isEmailVerified;
  String isPhoneVerified;

  Professor({
    required this.department,
    required this.email,
    required this.name,
    required this.password,
    required this.phonenumber,
    required this.professorId,
    required this.signaturecode,
    required this.profilePicture,
    required this.section,
    required this.subject,
    required this.day,
    required this.time,
    required this.room,
    required this.listeningTo,
    required this.isEmailVerified,
    required this.isPhoneVerified,
  });

  factory Professor.fromJson(Map<String, dynamic> json) => Professor(
        department: json["department"],
        email: json["email"],
        name: json["name"],
        password: json["password"],
        phonenumber: json["phonenumber"],
        professorId: json["professorID"],
        signaturecode: json["signaturecode"],
        profilePicture: json["profilePicture"],
        section: json["section"],
        subject: json["subject"],
        day: json["day"],
        time: json["time"],
        room: json["room"],
        listeningTo: json["listeningTo"],
        isEmailVerified: json["isEmailVerified"],
        isPhoneVerified: json["isPhoneVerified"],
      );

  Map<String, dynamic> toJson() => {
        "department": department,
        "email": email,
        "name": name,
        "password": password,
        "phonenumber": phonenumber,
        "professorID": professorId,
        "signaturecode": signaturecode,
        "profilePicture": profilePicture,
        "section": section,
        "subject": subject,
        "day": day,
        "time": time,
        "room": room,
        "listeningTo": listeningTo,
        "isEmailVerified": isEmailVerified,
        "isPhoneVerified": isPhoneVerified,
      };
}
