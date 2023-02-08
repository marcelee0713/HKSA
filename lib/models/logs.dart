import 'dart:convert';

Logs logsFromJson(String str) => Logs.fromJson(json.decode(str));

String logsToJson(Logs data) => json.encode(data.toJson());

class Logs {
  Logs({
    required this.timeIn,
    required this.timeOut,
    required this.signature,
    required this.date,
    required this.multiplier,
  });

  String timeIn;
  String timeOut;
  String signature;
  String date;
  String multiplier;

  factory Logs.fromJson(Map<String, dynamic> json) => Logs(
        timeIn: json["timeIn"],
        timeOut: json["timeOut"],
        signature: json["signature"],
        date: json["date"],
        multiplier: json["multiplier"],
      );

  Map<String, dynamic> toJson() => {
        "timeIn": timeIn,
        "timeOut": timeOut,
        "signature": signature,
        "date": date,
        "multiplier": multiplier,
      };
}
