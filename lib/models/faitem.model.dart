import 'dart:convert';

class Faitem {
  late int? faId;
  late int? tagNo;
  late String? assetName;
  late int? locId;
  late int? added;
  late String? disposed;
  late String? syncDate;
  late int? syncBy;

  Faitem({
    this.faId,
    this.tagNo,
    this.assetName,
    this.locId,
    this.added,
    this.disposed,
    this.syncDate,
    this.syncBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'faId': faId,
      'tagNo': tagNo,
      'assetName': assetName,
      'locId': locId,
      'added': added,
      'disposed': disposed,
      'syncDate': syncDate,
      'syncBy': syncBy,
    };
  }

  factory Faitem.fromMap(Map<String, dynamic> map) {
    return Faitem(
      faId: map['faId'],
      tagNo: map['tagNo'],
      assetName: map['assetName'],
      locId: map['locId'],
      added: map['added'],
      disposed: map['disposed'],
      syncDate: map['syncDate'],
      syncBy: map['syncBy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Faitem.fromJson(String source) => Faitem.fromMap(json.decode(source));
}
