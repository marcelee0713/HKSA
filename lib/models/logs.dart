import 'dart:convert';

Logs logsFromJson(String str) => Logs.fromJson(json.decode(str));

String logsToJson(Logs data) => json.encode(data.toJson());

class Logs {
  Logs({
    required this.timeIn,
    required this.timeOut,
    required this.profName,
    required this.date,
    required this.multiplier,
  });

  String timeIn;
  String timeOut;
  String profName;
  String date;
  String multiplier;

  factory Logs.fromJson(Map<String, dynamic> json) => Logs(
        timeIn: json["timeIn"],
        timeOut: json["timeOut"],
        profName: json["profName"],
        date: json["date"],
        multiplier: json["multiplier"],
      );

  Map<String, dynamic> toJson() => {
        "timeIn": timeIn,
        "timeOut": timeOut,
        "profName": profName,
        "date": date,
        "multiplier": multiplier,
      };
}
