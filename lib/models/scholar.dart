import 'dart:convert';

Scholar scholarFromJson(String str) => Scholar.fromJson(json.decode(str));

String scholarToJson(Scholar data) => json.encode(data.toJson());

class Scholar {
  String studentNumber;
  String name;
  String course;
  String email;
  String phonenumber;
  String password;
  String hours;
  String hkType;
  String status;
  String totalHoursInDisplay;
  String totalHoursInDuration;
  String totalHoursRequired;
  String isFinished;
  String profilePicture;
  String onSiteDay1;
  String onSiteDay2;
  String vacantTimeDay1;
  String vacantTimeDay2;
  String wholeDayVacantTime;
  String scholarType;
  String town;
  String assignedProfD1;
  String assignedProfD2;
  String assignedProfWd;
  String listeningTo;
  String isEmailVerified;
  String isPhoneVerified;

  Scholar({
    required this.studentNumber,
    required this.name,
    required this.course,
    required this.email,
    required this.phonenumber,
    required this.password,
    required this.hours,
    required this.hkType,
    required this.status,
    required this.totalHoursInDisplay,
    required this.totalHoursInDuration,
    required this.totalHoursRequired,
    required this.isFinished,
    required this.profilePicture,
    required this.onSiteDay1,
    required this.onSiteDay2,
    required this.vacantTimeDay1,
    required this.vacantTimeDay2,
    required this.wholeDayVacantTime,
    required this.scholarType,
    required this.town,
    required this.assignedProfD1,
    required this.assignedProfD2,
    required this.assignedProfWd,
    required this.listeningTo,
    required this.isEmailVerified,
    required this.isPhoneVerified,
  });

  factory Scholar.fromJson(Map<String, dynamic> json) => Scholar(
        studentNumber: json["studentNumber"],
        name: json["name"],
        course: json["course"],
        email: json["email"],
        phonenumber: json["phonenumber"],
        password: json["password"],
        hours: json["hours"],
        hkType: json["hkType"],
        status: json["status"],
        totalHoursInDisplay: json["totalHoursInDisplay"],
        totalHoursInDuration: json["totalHoursInDuration"],
        totalHoursRequired: json["totalHoursRequired"],
        isFinished: json["isFinished"],
        profilePicture: json["profilePicture"],
        onSiteDay1: json["onSiteDay1"],
        onSiteDay2: json["onSiteDay2"],
        vacantTimeDay1: json["vacantTimeDay1"],
        vacantTimeDay2: json["vacantTimeDay2"],
        wholeDayVacantTime: json["wholeDayVacantTime"],
        scholarType: json["scholarType"],
        town: json["town"],
        assignedProfD1: json["assignedProfD1"],
        assignedProfD2: json["assignedProfD2"],
        assignedProfWd: json["assignedProfWD"],
        listeningTo: json["listeningTo"],
        isEmailVerified: json["isEmailVerified"],
        isPhoneVerified: json["isPhoneVerified"],
      );

  Map<String, dynamic> toJson() => {
        "studentNumber": studentNumber,
        "name": name,
        "course": course,
        "email": email,
        "phonenumber": phonenumber,
        "password": password,
        "hours": hours,
        "hkType": hkType,
        "status": status,
        "totalHoursInDisplay": totalHoursInDisplay,
        "totalHoursInDuration": totalHoursInDuration,
        "totalHoursRequired": totalHoursRequired,
        "isFinished": isFinished,
        "profilePicture": profilePicture,
        "onSiteDay1": onSiteDay1,
        "onSiteDay2": onSiteDay2,
        "vacantTimeDay1": vacantTimeDay1,
        "vacantTimeDay2": vacantTimeDay2,
        "wholeDayVacantTime": wholeDayVacantTime,
        "scholarType": scholarType,
        "town": town,
        "assignedProfD1": assignedProfD1,
        "assignedProfD2": assignedProfD2,
        "assignedProfWD": assignedProfWd,
        "listeningTo": listeningTo,
        "isEmailVerified": isEmailVerified,
        "isPhoneVerified": isPhoneVerified,
      };
}
