import 'dart:io';

import 'package:myasset/models/contact.model.dart';
import 'package:myasset/models/preferences.model.dart';
import 'package:myasset/models/user.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  late Database _database;

  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'assets.db';

    //create, read databases
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  //buat tabel baru dengan nama contact
  void _createDb(Database db, int version) async {
    // periods
    await db.execute('''
      CREATE TABLE IF NOT EXISTS periods (
        periodId INTEGER PRIMARY KEY AUTOINCREMENT,
        periodName TEXT,
        startDate TEXT,
        endDate TEXT,
        closeActualDate TEXT,
        soStartDate TEXT,
        soEndDate TEXT,
        syncDate TEXT,
        syncBy INTEGER
      )
    ''');

    // users
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT,
        empNo TEXT,
        realName TEXT,
        roleId INTEGER,
        roleName TEXT,
        plantId INTEGER,
        locationId INTEGER,
        syncDate TEXT,
        syncBy INTEGER
      )
    ''');

    // statuses
    await db.execute('''
      CREATE TABLE IF NOT EXISTS statuses (
        genId INTEGER PRIMARY KEY AUTOINCREMENT,
        genCode TEXT,
        genName TEXT,
        genGroup TEXT,
        sort INTEGER,
        syncDate TEXT,
        syncBy INTEGER
      )
    ''');

    // fa item
    await db.execute('''
      CREATE TABLE IF NOT EXISTS faitems (
        faId INTEGER PRIMARY KEY AUTOINCREMENT,
        faNo TEXT,
        tagNo TEXT,
        assetName TEXT,
        locId INTEGER,
        added INTEGER,
        disposed TEXT,
        syncDate TEXT,
        syncBy INTEGER
      )
    ''');

    // so confirm
    await db.execute('''
      CREATE TABLE IF NOT EXISTS soconfirms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        soConfirmId INTEGER,
        periodId INTEGER,
        locId INTEGER,
        confirmDate TEXT,
        confirmBy TEXT,
        uploadDate TEXT,
        uploadBy INTEGER,
        uploadMessage TEXT
      )
    ''');

    // stockopname
    await db.execute('''
      CREATE TABLE IF NOT EXISTS stockopnames (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stockOpnameId INTEGER,
        periodId INTEGER,
        tagNo TEXT,
        description TEXT,
        faId INTEGER,
        faNo TEXT,
        locationId INTEGER,
        qty INTEGER,
        existStatCode TEXT,
        tagStatCode TEXT,
        usageStatCode TEXT,
        conStatCode TEXT,
        ownStatCode TEXT,
        syncDate TEXT,
        syncBy INTEGER,
        uploadDate TEXT,
        uploadBy INTEGER,
        uploadMessage TEXT
      )
    ''');

    // fa trans
    await db.execute('''
      CREATE TABLE IF NOT EXISTS fatrans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transId INTEGER,
        plantId INTEGER,
        transTypeCode TEXT,
        transDate TEXT,
        transNo TEXT,
        manualRef TEXT,
        otherRef TEXT,
        transferTypeCode TEXT,
        oldLocId INTEGER,
        oldLocCode TEXT,
        oldLocName TEXT,
        newLocId INTEGER,
        newLocCode TEXT,
        newLocName TEXT,
        isApproved INTEGER,
        isVoid INTEGER,
        saveDate TEXT,
        savedBy TEXT,
        uploadDate TEXT,
        uploadBy TEXT,
        uploadMessage TEXT,
        syncDate TEXT,
        syncBy INTEGER
      )
    ''');

    // fa trans item
    await db.execute('''
      CREATE TABLE IF NOT EXISTS fatransitem (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transId INTEGER,
        transItemId INTEGER,
        faItemId INTEGER,
        faId INTEGER,
        faNo TEXT,
        description TEXT,
        remarks TEXT,
        conStatCode TEXT,
        tagNo TEXT,
        saveDate TEXT,
        saveBy INTEGER,
        syncDate TEXT,
        syncBy INTEGER,
        uploadDate TEXT,
        uploadBy INTEGER,
        uploadMessage TEXT
      )
    ''');

    // locations
    await db.execute('''
      CREATE TABLE IF NOT EXISTS locations (
        locationId INTEGER PRIMARY KEY AUTOINCREMENT,
        locationCode TEXT,
        description TEXT,
        locTypeCode INTEGER,
        intransitId INTEGER,
        plantId INTEGER,
        entityCode TEXT,
        contactPerson TEXT,
        address TEXT,
        city TEXT,
        state TEXT,
        phones TEXT,
        fax TEXT,
        email TEXT,
        insertDate TEXT,
        insertBy INTEGER
      )
    ''');

    // fa so head
    await db.execute('''
      CREATE TABLE IF NOT EXISTS fasohead (
        soHeadId INTEGER PRIMARY KEY AUTOINCREMENT,
        periodId INTEGER,
        locationId INTEGER,
        soStatusCode TEXT,
        rejectNote TEXT
      )
    ''');
  }

  Future<List<Preferences>> initApp() async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('preferences');
    return List.generate(maps.length, (index) {
      return Preferences.fromMap(maps[index]);
    });
  }

  Future<void> initPref(Preferences pref) async {
    Database db = await initDb();
    await db.insert(
      'preferences',
      pref.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> initUser(User user) async {
    Database db = await initDb();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> selectUserToLogin(String username, String password) async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
      orderBy: 'realName',
    );
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<List<User>> selectUser() async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps =
        await db.query('users', orderBy: 'realName');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<List<Contact>> select() async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps =
        await db.query('contact', orderBy: 'name');
    print(maps);
    return List.generate(maps.length, (index) {
      return Contact(maps[index]['name'], maps[index]['phone']);
    });
  }

//create databases
  Future<int> insert(Contact object) async {
    Database db = await initDb();
    int count = await db.insert('contact', object.toMap());
    return count;
  }

//update databases
  Future<int> update(Contact object) async {
    Database db = await initDb();
    int count = await db.update('contact', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }

//delete databases
  Future<int> delete(String tableName, int id) async {
    Database db = await initDb();
    int count = await db.delete(tableName, where: 'id=?', whereArgs: [id]);
    return count;
  }
}
