class User {
  late int userId;
  late String username;
  late String password;
  late String empNo;
  late String realName;
  late int roleId;
  late String roleName;
  late int plantId;
  late int locationId;
  late String syncDate;
  late int syncBy;

  User(
    this.userId,
    this.username,
    this.password,
    this.empNo,
    this.realName,
    this.roleId,
    this.roleName,
    this.plantId,
    this.locationId,
    this.syncDate,
    this.syncBy,
  );

  User.fromMap(Map<String, dynamic> map) {
    userId = map['userId'];
    username = map['username'];
    password = map['password'];
    empNo = map['empNo'];
    realName = map['realName'];
    roleId = map['roleId'];
    roleName = map['roleName'];
    plantId = map['plantId'];
    locationId = map['locationId'];
    syncDate = map['syncDate'];
    syncBy = map['syncBy'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'empNo': empNo,
      'realName': realName,
      'roleId': roleId,
      'roleName': roleName,
      'plantId': plantId,
      'locationId': locationId,
      'syncDate': syncDate,
      'syncBy': syncBy,
    };
  }
}
