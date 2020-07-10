import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FavPlDb{
  static Future<Database> database;
  final String dbFileName = 'fav_playlist_db.db';
  final String dbTableName = 'favoritesPlaylist';

  initDb() async{
    FavPlDb.database = openDatabase(
      join(await getDatabasesPath(),dbFileName),
      version: 1,
      onCreate: (Database db,int version){
        db.execute('CREATE TABLE $dbTableName(id INTEGER PRIMARY KEY,title TEXT,filePath TEXT,albumArt TEXT)');
      }
    );
  }

  Future<int> insertSong(Map<String, dynamic> songToAdd) async{
    Database db = await database;

    int result = await db.insert(dbTableName, songToAdd,conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> removeSong(Map<String, dynamic> songToAdd) async{
    Database db = await database;

    int result = await db.delete(dbTableName,where: 'id = ?',whereArgs: songToAdd['id']);
    return result;
  }

  Future<List<Map<String,dynamic>>> readSongs() async{
    Database db = await database;

    List<Map<String,dynamic>> result = await db.rawQuery('SELECT * FROM $dbTableName');
    return result;
  }

}
