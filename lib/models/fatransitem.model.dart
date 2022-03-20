import 'dart:convert';

class Fatransitem {
  late int? id;
  late int? transItemId;
  late int? faItemId;
  late int? faId;
  late String? remarks;
  late String? conStatCode;
  late String? tagNo;
  late String? saveDate;
  late int? saveBy;
  late String? syncDate;
  late int? syncBy;
  late String? uploadDate;
  late int? uploadBy;
  late String? uploadMessage;
  Fatransitem({
    this.id,
    this.transItemId,
    this.faItemId,
    this.faId,
    this.remarks,
    this.conStatCode,
    this.tagNo,
    this.saveDate,
    this.saveBy,
    this.syncDate,
    this.syncBy,
    this.uploadDate,
    this.uploadBy,
    this.uploadMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transItemId': transItemId,
      'faItemId': faItemId,
      'faId': faId,
      'remarks': remarks,
      'conStatCode': conStatCode,
      'tagNo': tagNo,
      'saveDate': saveDate,
      'saveBy': saveBy,
      'syncDate': syncDate,
      'syncBy': syncBy,
      'uploadDate': uploadDate,
      'uploadBy': uploadBy,
      'uploadMessage': uploadMessage,
    };
  }

  factory Fatransitem.fromMap(Map<String, dynamic> map) {
    return Fatransitem(
      id: map['id'],
      transItemId: map['transItemId'],
      faItemId: map['faItemId'],
      faId: map['faId'],
      remarks: map['remarks'],
      conStatCode: map['conStatCode'],
      tagNo: map['tagNo'],
      saveDate: map['saveDate'],
      saveBy: map['saveBy'],
      syncDate: map['syncDate'],
      syncBy: map['syncBy'],
      uploadDate: map['uploadDate'],
      uploadBy: map['uploadBy'],
      uploadMessage: map['uploadMessage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Fatransitem.fromJson(String source) =>
      Fatransitem.fromMap(json.decode(source));
}
