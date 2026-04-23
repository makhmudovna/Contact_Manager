import 'package:contact_manager/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactRepository {
  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'contact_manager.db');

    final database = await openDatabase('contact_manager.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
       CREATE TABLE contacts (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT,
       email TEXT,
       phone TEXT,
       adress TEXT
       )''');

      //insert some initial rows
      await db.insert('contacts', {
        'name': 'John Smith',
        'email': 'john@gmail.com',
        'phone': '12345678',
        'adress': 'New York'
      });

      await db.insert('contacts', {
        'name': 'Bob Smith',
        'email': 'bob@gmail.com',
        'phone': '87654321',
        'adress': 'Miami, USA'
      });
    });

    return database;
  }

  static Future<List<Contact>> getContacts() async {
    final db = await _getDatabase();
    final result = await db.query('contacts');
    return result.map((json) => Contact.fromMap(json)).toList();
  }

  static Future<int> addContact(Contact contact) async {
    final db = await _getDatabase();
    return await db.insert('contacts', contact.toMap());
  }

  static Future<int> updateContact(Contact contact) async {
    final db = await _getDatabase();
    return await db.update('contacts', contact.toMap(),
        where: 'id = ?', whereArgs: [contact.id]);
  }

  static Future<int> deleteContact(int id) async {
    final db = await _getDatabase();
    int result = await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );

    print("Deleted rows: $result");
    return result;
  }
}
