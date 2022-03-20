import 'dart:convert';

class Preferences {
  late int id;
  late String registered;
  late String apiAddress;
  late int locationId;
  late String locationCode;
  late String locationName;
  late int intransitId;
  late String intransitCode;
  late String intransitName;
  late int plantId;
  late String plantName;
  late int userId;
  late String token;
  late int isOnline;
  late int periodId;

  Preferences(
    this.id,
    this.registered,
    this.apiAddress,
    this.locationId,
    this.locationCode,
    this.locationName,
    this.intransitId,
    this.intransitCode,
    this.intransitName,
    this.plantId,
    this.plantName,
    this.userId,
    this.token,
    this.isOnline,
    this.periodId,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registered': registered,
      'apiAddress': apiAddress,
      'locationId': locationId,
      'locationCode': locationCode,
      'locationName': locationName,
      'intransitId': intransitId,
      'intransitCode': intransitCode,
      'intransitName': intransitName,
      'plantId': plantId,
      'plantName': plantName,
      'userId': userId,
      'token': token,
      'isOnline': isOnline,
      'periodId': periodId,
    };
  }

  Preferences.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    registered = map['registered'];
    apiAddress = map['apiAddress'];
    locationId = map['locationId'];
    locationCode = map['locationCode'];
    locationName = map['locationName'];
    intransitId = map['intransitId'];
    intransitCode = map['intransitCode'];
    intransitName = map['intransitName'];
    plantId = map['plantId'];
    plantName = map['plantName'];
    userId = map['userId'];
    token = map['token'];
    isOnline = map['isOnline'];
    periodId = map['periodId'];
  }

  String toJson() => json.encode(toMap());

  factory Preferences.fromJson(String source) =>
      Preferences.fromMap(json.decode(source));
}
