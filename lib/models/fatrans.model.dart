import 'dart:convert';

class Fatrans {
  late int? id;
  late int? transId;
  late int? plantId;
  late String? transTypeCode;
  late String? transDate;
  late String? transNo;
  late String? manualRef;
  late String? otherRef;
  late String? transgerTypeCode;
  late int? oldLocId;
  late int? newLocId;
  late int? isApproved;
  late int? isVoid;
  late String? saveDate;
  late String? savedBy;
  late String? uploadDate;
  late String? uploadBy;
  late String? uploadMessage;
  late String? syncDate;
  late int? syncBy;

  Fatrans({
    this.id,
    this.transId,
    this.plantId,
    this.transTypeCode,
    this.transDate,
    this.transNo,
    this.manualRef,
    this.otherRef,
    this.transgerTypeCode,
    this.oldLocId,
    this.newLocId,
    this.isApproved,
    this.isVoid,
    this.saveDate,
    this.savedBy,
    this.uploadDate,
    this.uploadBy,
    this.uploadMessage,
    this.syncDate,
    this.syncBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transId': transId,
      'plantId': plantId,
      'transTypeCode': transTypeCode,
      'transDate': transDate,
      'transNo': transNo,
      'manualRef': manualRef,
      'otherRef': otherRef,
      'transgerTypeCode': transgerTypeCode,
      'oldLocId': oldLocId,
      'newLocId': newLocId,
      'isApproved': isApproved,
      'isVoid': isVoid,
      'saveDate': saveDate,
      'savedBy': savedBy,
      'uploadDate': uploadDate,
      'uploadBy': uploadBy,
      'uploadMessage': uploadMessage,
      'syncDate': syncDate,
      'syncBy': syncBy,
    };
  }

  factory Fatrans.fromMap(Map<String, dynamic> map) {
    return Fatrans(
      id: map['id'],
      transId: map['transId'],
      plantId: map['plantId'],
      transTypeCode: map['transTypeCode'],
      transDate: map['transDate'],
      transNo: map['transNo'],
      manualRef: map['manualRef'],
      otherRef: map['otherRef'],
      transgerTypeCode: map['transgerTypeCode'],
      oldLocId: map['oldLocId'],
      newLocId: map['newLocId'],
      isApproved: map['isApproved'],
      isVoid: map['isVoid'],
      saveDate: map['saveDate'],
      savedBy: map['savedBy'],
      uploadDate: map['uploadDate'],
      uploadBy: map['uploadBy'],
      uploadMessage: map['uploadMessage'],
      syncDate: map['syncDate'],
      syncBy: map['syncBy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Fatrans.fromJson(String source) =>
      Fatrans.fromMap(json.decode(source));
}
