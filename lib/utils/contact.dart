import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String descriptionColumn = "descriptionColumn";
final String moodColumn = "moodColumn";
final String dateColumn = "dateColumn";
final String imgColumn = "imgColumn";

// Essa classe é um singleton com a linha 9 até linha 13
class ContactUtils {
  static final ContactUtils _instance = ContactUtils.internal();

  factory ContactUtils() => _instance;

  ContactUtils.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "diario.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $moodColumn TEXT, $descriptionColumn TEXT,"
          "$dateColumn TEXT, $imgColumn TEXT)");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database _database = await db;
    contact.id = await _database.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database _database = await db;
    List listContact = await _database.query(contactTable,
        columns: [idColumn, nameColumn, moodColumn, descriptionColumn, dateColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (listContact.length > 0) {
      return Contact.fromMap(listContact.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    Database _database = await db;
    return await _database
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> update(Contact contact) async {
    Database _database = await db;
    return await _database.update(
      contactTable,
      contact.toMap(),
      where: "$idColumn = ?",
      whereArgs: [contact.id],
    );
  }

  Future<List> getAllContacts() async {
    Database _database = await db;
    List listMap = await _database.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = [];
    for (Map map in listMap) {
      listContact.add(Contact.fromMap(map));
    }
    return listContact;
  }

}

class Contact {
  int id;
  String name;
  String mood;
  String description;
  String date;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    mood = map[moodColumn];
    description = map[descriptionColumn];
    date = map[dateColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      moodColumn: mood,
      descriptionColumn: description,
      dateColumn: date,
      imgColumn: img
    };

    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
