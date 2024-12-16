import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:virtual_card/models/contact_model.dart';

class DbHelper {
  Database? _db;

  final String _createTableContact = '''
create table $tableContact(
$tblContactColId integer primary key autoincrement,
$tblContactColName text not null,
$tblContactColAddress text,
$tblContactColDesgnation text,
$tblContactColCompany text,
$tblContactColEmail text,
$tblContactColMobile text not null,
$tblContactColFavorite integer not null,
$tblContactColWebsite text,
$tblContactColImage text)''';

  Future<Database> _open() async {
    if (_db != null) {
      return _db!;
    }
    final root = await getDatabasesPath();
    final dbPath = p.join(root, 'contact.db');
    _db = await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(_createTableContact);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion == 1) {
          await db
              .execute('alter table $tableContact rename to ${'contact_old'}');
          await db.execute(_createTableContact);
          final rows = await db.query('contact_old');
          for (var row in rows) {
            await db.insert(tableContact, row);
          }
          await db.execute('drop table if exists ${'contact_old'}');
          
        }
      },
    );
    return _db!;
  }

  Future<void> _close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
    }
    _db = null;
  }

  Future<int> insertContact(ContactModel contactModel) async {
    try {
      final db = await _open();
      final result = await db.insert(tableContact, contactModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('Contact inserted with id: $result');
      return result;
    } catch (e) {
      print('Error inserting contact: $e');
      return -1;
    }
  }

  Future<List<ContactModel>> getAllContacts() async {
    
      final db = await _open();
      final mapList = await db.query(tableContact);
      return List.generate(
          mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }
  Future<ContactModel> getContactById(int id) async {
    
      final db = await _open();
      final mapList = await db.query(tableContact, where: '$tblContactColId= ?', whereArgs: [id]);
      return ContactModel.fromMap(mapList.first);
  }

  Future<int> deleteContact(int id) async {
    final db = await _open();
    return db
        .delete(tableContact, where: '$tblContactColId= ?', whereArgs: [id]);
  }

//   Future<int> updateContactField(int id,Map<String,dynamic> map)async{
//  turn db.update(tableContact, map,where: '$tblContactColId= ?',whereArgs: [id]);
//   }
  Future<int> updateFavorite(int id, int value) async {
    final db = await _open();
    return db.update(tableContact, {tblContactColFavorite: value},
        where: '$tblContactColId= ?', whereArgs: [id]);
  }

  Future<List<ContactModel>> getFavoriteContacts() async {
    final db = await _open();
    final mapList = await db.query(
      tableContact,
      where: '$tblContactColFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(
        mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  Future<int> updateContact(ContactModel contactModel) async {
    final db = await _open();
    return db.update(
      tableContact,
      contactModel.toMap(),
      where: '$tblContactColId = ?',
      whereArgs: [contactModel.id],
    );
  }

  Future<List<ContactModel>> getAllFavoriteContacts() async {
    try {
      final db = await _open();
      final mapList = await db.query(tableContact,
          where: '$tblContactColFavorite = ?', whereArgs: [1]);
      return List.generate(
          mapList.length, (index) => ContactModel.fromMap(mapList[index]));
    } catch (e) {
      print('Error getting contacts: $e');
      return [];
    }
  }
}
