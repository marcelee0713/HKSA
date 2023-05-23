import 'dart:convert';

Scholar scholarFromJson(String str) => Scholar.fromJson(json.decode(str));

String scholarToJson(Scholar data) => json.encode(data.toJson());

class Scholar {
  String assignedProfD1;
  String assignedProfD2;
  String assignedProfWd;
  String course;
  String email;
  String hkType;
  String hours;
  String isEmailVerified;
  String isFinished;
  String isPhoneVerified;
  String listeningTo;
  String name;
  String onSiteDay1;
  String onSiteDay2;
  String phonenumber;
  String profilePicture;
  String scholarType;
  String status;
  String studentNumber;
  String totalHoursInDisplay;
  String totalHoursInDuration;
  String totalHoursRequired;
  String town;
  String uid;
  String vacantTimeDay1;
  String vacantTimeDay2;
  String wholeDayVacantTime;

  Scholar({
    required this.assignedProfD1,
    required this.assignedProfD2,
    required this.assignedProfWd,
    required this.course,
    required this.email,
    required this.hkType,
    required this.hours,
    required this.isEmailVerified,
    required this.isFinished,
    required this.isPhoneVerified,
    required this.listeningTo,
    required this.name,
    required this.onSiteDay1,
    required this.onSiteDay2,
    required this.phonenumber,
    required this.profilePicture,
    required this.scholarType,
    required this.status,
    required this.studentNumber,
    required this.totalHoursInDisplay,
    required this.totalHoursInDuration,
    required this.totalHoursRequired,
    required this.town,
    required this.uid,
    required this.vacantTimeDay1,
    required this.vacantTimeDay2,
    required this.wholeDayVacantTime,
  });

  factory Scholar.fromJson(Map<String, dynamic> json) => Scholar(
        assignedProfD1: json["assignedProfD1"],
        assignedProfD2: json["assignedProfD2"],
        assignedProfWd: json["assignedProfWD"],
        course: json["course"],
        email: json["email"],
        hkType: json["hkType"],
        hours: json["hours"],
        isEmailVerified: json["isEmailVerified"],
        isFinished: json["isFinished"],
        isPhoneVerified: json["isPhoneVerified"],
        listeningTo: json["listeningTo"],
        name: json["name"],
        onSiteDay1: json["onSiteDay1"],
        onSiteDay2: json["onSiteDay2"],
        phonenumber: json["phonenumber"],
        profilePicture: json["profilePicture"],
        scholarType: json["scholarType"],
        status: json["status"],
        studentNumber: json["studentNumber"],
        totalHoursInDisplay: json["totalHoursInDisplay"],
        totalHoursInDuration: json["totalHoursInDuration"],
        totalHoursRequired: json["totalHoursRequired"],
        town: json["town"],
        uid: json["uid"],
        vacantTimeDay1: json["vacantTimeDay1"],
        vacantTimeDay2: json["vacantTimeDay2"],
        wholeDayVacantTime: json["wholeDayVacantTime"],
      );

  Map<String, dynamic> toJson() => {
        "assignedProfD1": assignedProfD1,
        "assignedProfD2": assignedProfD2,
        "assignedProfWD": assignedProfWd,
        "course": course,
        "email": email,
        "hkType": hkType,
        "hours": hours,
        "isEmailVerified": isEmailVerified,
        "isFinished": isFinished,
        "isPhoneVerified": isPhoneVerified,
        "listeningTo": listeningTo,
        "name": name,
        "onSiteDay1": onSiteDay1,
        "onSiteDay2": onSiteDay2,
        "phonenumber": phonenumber,
        "profilePicture": profilePicture,
        "scholarType": scholarType,
        "status": status,
        "studentNumber": studentNumber,
        "totalHoursInDisplay": totalHoursInDisplay,
        "totalHoursInDuration": totalHoursInDuration,
        "totalHoursRequired": totalHoursRequired,
        "town": town,
        "uid": uid,
        "vacantTimeDay1": vacantTimeDay1,
        "vacantTimeDay2": vacantTimeDay2,
        "wholeDayVacantTime": wholeDayVacantTime,
      };
}
