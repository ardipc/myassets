import 'dart:convert';

class Period {
  late int? periodId;
  late String? periodName;
  late String? startDate;
  late String? endDate;
  late String? closeActualDate;
  late String? soStartDate;
  late String? soEndDate;
  late String? syncDate;
  late int? syncBy;

  Period({
    this.periodId,
    this.periodName,
    this.startDate,
    this.endDate,
    this.closeActualDate,
    this.soStartDate,
    this.soEndDate,
    this.syncDate,
    this.syncBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'periodId': periodId,
      'periodName': periodName,
      'startDate': startDate,
      'endDate': endDate,
      'closeActualDate': closeActualDate,
      'soStartDate': soStartDate,
      'soEndDate': soEndDate,
      'syncDate': syncDate,
      'syncBy': syncBy,
    };
  }

  Period.fromMap(Map<String, dynamic> map) {
    periodId = map['periodId'];
    periodName = map['periodName'];
    startDate = map['startDate'];
    endDate = map['endDate'];
    closeActualDate = map['closeActualDate'];
    soStartDate = map['soStartDate'];
    soEndDate = map['soEndDate'];
    syncDate = map['syncDate'];
    syncBy = map['syncBy'];
  }

  String toJson() => json.encode(toMap());

  factory Period.fromJson(String source) => Period.fromMap(json.decode(source));
}
