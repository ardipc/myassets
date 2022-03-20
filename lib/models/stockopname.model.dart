import 'dart:convert';

class Stockopname {
  late int? id;
  late int? stockOpnameId;
  late int? periodId;
  late int? faId;
  late int? locationId;
  late int? qty;
  late String? existStatCode;
  late String? tagStatCode;
  late String? usageStatCode;
  late String? conStatCode;
  late String? ownStatCode;
  late String? syncDate;
  late int? syncBy;
  late String? uploadDate;
  late int? uploadBy;
  late String? uploadMessage;

  Stockopname({
    this.id,
    this.stockOpnameId,
    this.periodId,
    this.faId,
    this.locationId,
    this.qty,
    this.existStatCode,
    this.tagStatCode,
    this.usageStatCode,
    this.conStatCode,
    this.ownStatCode,
    this.syncDate,
    this.syncBy,
    this.uploadDate,
    this.uploadBy,
    this.uploadMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stockOpnameId': stockOpnameId,
      'periodId': periodId,
      'faId': faId,
      'locationId': locationId,
      'qty': qty,
      'existStatCode': existStatCode,
      'tagStatCode': tagStatCode,
      'usageStatCode': usageStatCode,
      'conStatCode': conStatCode,
      'ownStatCode': ownStatCode,
      'syncDate': syncDate,
      'syncBy': syncBy,
      'uploadDate': uploadDate,
      'uploadBy': uploadBy,
      'uploadMessage': uploadMessage,
    };
  }

  factory Stockopname.fromMap(Map<String, dynamic> map) {
    return Stockopname(
      id: map['id'],
      stockOpnameId: map['stockOpnameId'],
      periodId: map['periodId'],
      faId: map['faId'],
      locationId: map['locationId'],
      qty: map['qty'],
      existStatCode: map['existStatCode'],
      tagStatCode: map['tagStatCode'],
      usageStatCode: map['usageStatCode'],
      conStatCode: map['conStatCode'],
      ownStatCode: map['ownStatCode'],
      syncDate: map['syncDate'],
      syncBy: map['syncBy'],
      uploadDate: map['uploadDate'],
      uploadBy: map['uploadBy'],
      uploadMessage: map['uploadMessage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Stockopname.fromJson(String source) =>
      Stockopname.fromMap(json.decode(source));
}
