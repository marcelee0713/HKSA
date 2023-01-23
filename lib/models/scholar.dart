class Scholar {
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
  });

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
      };
}
