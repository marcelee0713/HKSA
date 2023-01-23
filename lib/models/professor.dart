import 'dart:convert';

Professor professorFromJson(String str) => Professor.fromJson(json.decode(str));

String professorToJson(Professor data) => json.encode(data.toJson());

class Professor {
  Professor({
    required this.department,
    required this.email,
    required this.name,
    required this.password,
    required this.phonenumber,
    required this.professorId,
    required this.signaturecode,
  });

  String department;
  String email;
  String name;
  String password;
  String phonenumber;
  String professorId;
  String signaturecode;

  factory Professor.fromJson(Map<String, dynamic> json) => Professor(
        department: json["department"],
        email: json["email"],
        name: json["name"],
        password: json["password"],
        phonenumber: json["phonenumber"],
        professorId: json["professorID"],
        signaturecode: json["signaturecode"],
      );

  Map<String, dynamic> toJson() => {
        "department": department,
        "email": email,
        "name": name,
        "password": password,
        "phonenumber": phonenumber,
        "professorID": professorId,
        "signaturecode": signaturecode,
      };
}
