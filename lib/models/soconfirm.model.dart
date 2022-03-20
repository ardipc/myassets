import 'dart:convert';

class Soconfirm {
  late int? id;
  late int? soConfirmId;
  late int? periodId;
  late int? locId;
  late String? confirmDate;
  late String? confirmBy;
  late String? uploadDate;
  late int? uploadBy;
  late String? uploadMessage;

  Soconfirm({
    this.id,
    this.soConfirmId,
    this.locId,
    this.confirmDate,
    this.confirmBy,
    this.uploadDate,
    this.uploadBy,
    this.uploadMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'soConfirmId': soConfirmId,
      'locId': locId,
      'confirmDate': confirmDate,
      'confirmBy': confirmBy,
      'uploadDate': uploadDate,
      'uploadBy': uploadBy,
      'uploadMessage': uploadMessage,
    };
  }

  factory Soconfirm.fromMap(Map<String, dynamic> map) {
    return Soconfirm(
      id: map['id'],
      soConfirmId: map['soConfirmId'],
      locId: map['locId'],
      confirmDate: map['confirmDate'],
      confirmBy: map['confirmBy'],
      uploadDate: map['uploadDate'],
      uploadBy: map['uploadBy'],
      uploadMessage: map['uploadMessage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Soconfirm.fromJson(String source) =>
      Soconfirm.fromMap(json.decode(source));
}
