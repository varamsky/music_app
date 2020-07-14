import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PlListDb{
  static Future<Database> _db;
  final String dbFileName = 'playlist_list_db.db';
  final String dbTableName = 'playlistList';

  Future<Database> get database async{
    if(PlListDb._db == null)
      await initDb();

    return PlListDb._db;
  }

  initDb() async{
    PlListDb._db = openDatabase(
        join(await getDatabasesPath(),dbFileName),
        version: 1,
        onCreate: (Database db,int version){
          db.execute('CREATE TABLE $dbTableName(id INTEGER PRIMARY KEY,dbName TEXT)');
        }
    );
  }

  Future<int> insertPlaylist(Map<String, dynamic> dbToAdd) async{
    Database db = await database;

    int result = await db.insert(dbTableName, dbToAdd,conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> removePlaylist(Map<String, dynamic> dbToAdd) async{
    Database db = await database;

    int result = await db.delete(dbTableName,where: 'id = ?',whereArgs: dbToAdd['id']);
    return result;
  }

  Future<List<Map<String,dynamic>>> readPlaylists() async{
    Database db = await database;

    List<Map<String,dynamic>> result = await db.rawQuery('SELECT * FROM $dbTableName');
    return result;
  }

  /*// check if song is already favorite i.e, is already included in db
  Future<List<Map<String,dynamic>>> checkSong(String title,String filePath) async{
    Database db = await database;

    List<Map<String,dynamic>> result = await db.rawQuery('SELECT * FROM $dbTableName WHERE title="$title" AND filePath="$filePath"');
    print('checkSong() result => $result');
    return result;
  }*/

}