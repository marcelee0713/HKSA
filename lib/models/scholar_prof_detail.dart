import 'dart:convert';

ScholarProfDetail scholarProfDetailFromJson(String str) =>
    ScholarProfDetail.fromJson(json.decode(str));

String scholarProfDetailToJson(ScholarProfDetail data) =>
    json.encode(data.toJson());

class ScholarProfDetail {
  ScholarProfDetail({
    required this.d1ProfSection,
    required this.d1ProfRoom,
    required this.d1ProfName,
    required this.d2ProfSection,
    required this.d2ProfRoom,
    required this.d2ProfName,
    required this.wDProfSection,
    required this.wDProfRoom,
    required this.wDProfName,
  });

  String d1ProfSection;
  String d1ProfRoom;
  String d1ProfName;
  String d2ProfSection;
  String d2ProfRoom;
  String d2ProfName;
  String wDProfSection;
  String wDProfRoom;
  String wDProfName;

  factory ScholarProfDetail.fromJson(Map<String, dynamic> json) =>
      ScholarProfDetail(
        d1ProfSection: json["d1ProfSection"],
        d1ProfRoom: json["d1ProfRoom"],
        d1ProfName: json["d1ProfName"],
        d2ProfSection: json["d2ProfSection"],
        d2ProfRoom: json["d2ProfRoom"],
        d2ProfName: json["d2ProfName"],
        wDProfSection: json["wDProfSection"],
        wDProfRoom: json["wDProfRoom"],
        wDProfName: json["wDProfName"],
      );

  Map<String, dynamic> toJson() => {
        "d1ProfSection": d1ProfSection,
        "d1ProfRoom": d1ProfRoom,
        "d1ProfName": d1ProfName,
        "d2ProfSection": d2ProfSection,
        "d2ProfRoom": d2ProfRoom,
        "d2ProfName": d2ProfName,
        "wDProfSection": wDProfSection,
        "wDProfRoom": wDProfRoom,
        "wDProfName": wDProfName,
      };
}
