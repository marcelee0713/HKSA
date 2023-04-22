import 'dart:convert';

ProfScheduleMatch profScheduleMatchFromJson(String str) =>
    ProfScheduleMatch.fromJson(json.decode(str));

String profScheduleMatchToJson(ProfScheduleMatch data) =>
    json.encode(data.toJson());

class ProfScheduleMatch {
  ProfScheduleMatch({
    required this.name,
    required this.id,
    required this.day,
    required this.time,
  });

  String name;
  String id;
  String day;
  String time;

  factory ProfScheduleMatch.fromJson(Map<String, dynamic> json) =>
      ProfScheduleMatch(
        name: json["name"],
        id: json["id"],
        day: json["day"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "day": day,
        "time": time,
      };
}
