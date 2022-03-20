import 'dart:convert';

class Status {
  late int? genId;
  late String? genCode;
  late String? genName;
  late String? genGroup;
  late int? sort;
  late String? syncDate;
  late int? syncBy;

  Status({
    this.genId,
    this.genCode,
    this.genName,
    this.genGroup,
    this.sort,
    this.syncDate,
    this.syncBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'genId': genId,
      'genCode': genCode,
      'genName': genName,
      'genGroup': genGroup,
      'sort': sort,
      'syncDate': syncDate,
      'syncBy': syncBy,
    };
  }

  Status.fromMap(Map<String, dynamic> map) {
    genId = map['genId'];
    genCode = map['genCode'];
    genName = map['genName'];
    genGroup = map['genGroup'];
    sort = map['sort'];
    syncDate = map['syncDate'];
    syncBy = map['syncBy'];
  }

  String toJson() => json.encode(toMap());

  factory Status.fromJson(String source) => Status.fromMap(json.decode(source));
}
