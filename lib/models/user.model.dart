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
    this.username = map['username'];
    this.password = map['password'];
    this.empNo = map['empNo'];
    this.realName = map['realName'];
    this.roleId = map['roleId'];
    this.roleName = map['roleName'];
    this.plantId = map['plantId'];
    this.locationId = map['locationId'];
    this.syncDate = map['syncDate'];
    this.syncBy = map['syncBy'];
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
