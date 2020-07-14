import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FavPlDb{
  static Future<Database> _db;
  final String dbFileName = 'fav_playlist_db.db';
  final String dbTableName = 'favoritesPlaylist';

  Future<Database> get database async{
    if(FavPlDb._db == null)
      await initDb();

    return FavPlDb._db;
  }


  initDb() async{
    FavPlDb._db = openDatabase(
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
    print('readSongs result from db.dart $result');
    return result;
  }

  // check if song is already favorite i.e, is already included in db
  Future<List<Map<String,dynamic>>> checkSong(String title,String filePath) async{
    Database db = await database;

    List<Map<String,dynamic>> result = await db.rawQuery('SELECT * FROM $dbTableName WHERE title="$title" AND filePath="$filePath"');
    print('checkSong() result => $result');
    return result;
  }

}
