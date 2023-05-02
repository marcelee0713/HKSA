import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  String desc;
  String timeStamp;
  String userType;
  String id;

  History({
    required this.desc,
    required this.timeStamp,
    required this.userType,
    required this.id,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        desc: json["desc"],
        timeStamp: json["timeStamp"],
        userType: json["userType"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "timeStamp": timeStamp,
        "userType": userType,
        "id": id,
      };
}
