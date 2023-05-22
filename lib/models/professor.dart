import 'dart:convert';

Professor professorFromJson(String str) => Professor.fromJson(json.decode(str));

String professorToJson(Professor data) => json.encode(data.toJson());

class Professor {
  String day;
  String department;
  String email;
  String isEmailVerified;
  String isPhoneVerified;
  String listeningTo;
  String name;
  String phonenumber;
  String professorId;
  String profilePicture;
  String room;
  String section;
  String signaturecode;
  String subject;
  String time;

  Professor({
    required this.day,
    required this.department,
    required this.email,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.listeningTo,
    required this.name,
    required this.phonenumber,
    required this.professorId,
    required this.profilePicture,
    required this.room,
    required this.section,
    required this.signaturecode,
    required this.subject,
    required this.time,
  });

  factory Professor.fromJson(Map<String, dynamic> json) => Professor(
        day: json["day"],
        department: json["department"],
        email: json["email"],
        isEmailVerified: json["isEmailVerified"],
        isPhoneVerified: json["isPhoneVerified"],
        listeningTo: json["listeningTo"],
        name: json["name"],
        phonenumber: json["phonenumber"],
        professorId: json["professorID"],
        profilePicture: json["profilePicture"],
        room: json["room"],
        section: json["section"],
        signaturecode: json["signaturecode"],
        subject: json["subject"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "department": department,
        "email": email,
        "isEmailVerified": isEmailVerified,
        "isPhoneVerified": isPhoneVerified,
        "listeningTo": listeningTo,
        "name": name,
        "phonenumber": phonenumber,
        "professorID": professorId,
        "profilePicture": profilePicture,
        "room": room,
        "section": section,
        "signaturecode": signaturecode,
        "subject": subject,
        "time": time,
      };
}
