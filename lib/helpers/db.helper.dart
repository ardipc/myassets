import 'dart:io';

import 'package:myasset/models/contact.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  late DbHelper _dbHelper;
  late Database _database;

  DbHelper._createObject();

  DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    // return _dbHelper;
  }

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
    await db.execute('''
      CREATE TABLE IF NOT EXISTS contact (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
      )
    ''');

    // preferences
    await db.execute('''
      CREATE TABLE IF NOT EXISTS preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        registered TEXT,
        apiAddress TEXT,
        locationId INTEGER,
        locationCode TEXT,
        locationName TEXT,
        intransitId INTEGER,
        intransitCode TEXT,
        intransitName TEXT,
        plantId INTEGER,
        plantName TEXT,
        userId INTEGER,
        token TEXT,
        isOnline INTEGER,
        periodId INTEGER
      )
    ''');

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

    // stockopname
    await db.execute('''
      CREATE TABLE IF NOT EXISTS stockopnames (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stockOpnameId INTEGER,
        periodId INTEGER,
        faId INTEGER,
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
        transgerTypeCode TEXT,
        oldLocId INTEGER,
        newLocId INTEGER,
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

    // fa item
    await db.execute('''
      CREATE TABLE IF NOT EXISTS faitems (
        faId INTEGER PRIMARY KEY AUTOINCREMENT,
        tagNo INTEGER,
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

    // fa trans item
    await db.execute('''
      CREATE TABLE IF NOT EXISTS fatransitem (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transItemId INTEGER,
        faItemId INTEGER,
        faId INTEGER,
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
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('contact', orderBy: 'name');
    return mapList;
  }

//create databases
  Future<int> insert(Contact object) async {
    Database db = await this.database;
    int count = await db.insert('contact', object.toMap());
    return count;
  }

//update databases
  Future<int> update(Contact object) async {
    Database db = await this.database;
    int count = await db.update('contact', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }

//delete databases
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('contact', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Contact>> getContactList() async {
    var contactMapList = await select();
    int count = contactMapList.length;
    List<Contact> contactList = <Contact>[];
    for (int i = 0; i < count; i++) {
      contactList.add(Contact.fromMap(contactMapList[i]));
    }
    return contactList;
  }
}
