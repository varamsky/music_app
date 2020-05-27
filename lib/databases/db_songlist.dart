import 'dart:io';

import 'package:music_app/model/db_Song_Info_Model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbSongList{
  static DbSongList _dbSongList;
  static Database _db;

  // 'st' denotes variables related to SongTable
  String stTableName = 'ST_SONG_LIST_TABLE';
  String stColId = 'ST_COL_ID';
  String stColTitle = 'ST_COL_TITLE';
  String stColTrack = 'ST_COL_TRACK';
  String stColDuration = 'ST_COL_DURATION';
  String stColFilePath = 'ST_COL_FILE_PATH';
  String stColFileSize = 'ST_COL_FILE_SIZE';
  String stColAlbumArtwork = 'ST_COL_ALBUM_ARTWORK';
  String stColAlbumId = 'ST_COL_ALBUM_ID';
  String stColArtistId = 'ST_COL_ARTIST_ID';
  String stColArtist = 'ST_COL_ARTIST';
  String stColAlbum = 'ST_COL_ALBUM';
  String stColDisplayName = 'ST_COL_DISPLAY_NAME';
  String stColComposer = 'ST_COL_COMPOSER';
  String stColYear = 'ST_COL_YEAR';




  DbSongList._createInstance();

  factory DbSongList(){
    if(_dbSongList == null)
      _dbSongList = DbSongList._createInstance();

    return _dbSongList;
  }

  Future<Database> get database async{
    if(_db == null)
      _db = await initDb();

    return _db;
  }

  Future<Database> initDb() async{
    String path = (await getApplicationDocumentsDirectory()).path + 'db_songs.db';

    Database database = await openDatabase(path,version: 1,onCreate: _createDb,);
    return database;
  }

  void _createDb(Database db,int newVersion) async{
    await db.execute('CREATE TABLE $stTableName($stColId INTEGER PRIMARY KEY, $stColTitle TEXT, $stColTrack TEXT, $stColDuration TEXT, $stColFilePath TEXT)');
    print('\n\nTable $stTableName created\n\n');
    await db.execute('SELECT * FROM $stTableName');

  }










  // INSERT
  Future<int> saveSong(DbSongInfoModel dbSongInfoModel) async{
    Directory directory = await getApplicationDocumentsDirectory();

    print('Directory path : ${directory.path}');

    var db = await this.database;
    //int result = await db.insert(stTableName, dbSongInfoModel.toMap());
    print('in saveSong() before execute');
    print('SQL STATEMENT :: INSERT INTO $stTableName($stColId, $stColTitle, $stColTrack, $stColDuration, $stColFilePath) VALUES(\'${dbSongInfoModel.getStSongId}\', \'${dbSongInfoModel.getStSongTitle}\', \'${dbSongInfoModel.getStSongTrack}\', \'${dbSongInfoModel.getStSongDuration}\', \'${dbSongInfoModel.getStSongFilePath}\')');

    await db.execute('INSERT INTO $stTableName($stColId, $stColTitle, $stColTrack, $stColDuration, $stColFilePath) VALUES(\'${dbSongInfoModel.getStSongId}\', \'${dbSongInfoModel.getStSongTitle}\', \'${dbSongInfoModel.getStSongTrack}\', \'${dbSongInfoModel.getStSongDuration}\', \'${dbSongInfoModel.getStSongFilePath}\')');
    print('in saveSong() after execute');

    int result = 1;

    print('Insert result : ${result.toString()}');
    return result;
  }

  //GET
  Future<DbSongInfoModel> getSong(int id) async{
    var db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $stTableName WHERE id = $id');
    return (result.length == 0) ? null : DbSongInfoModel.fromMap(result.first);
  }

  Future<int> getCount() async{
    var db = await this.database;
    int result = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $stTableName'));
    return result;
  }

  void printAll() async{
    var db = await this.database;
    await db.execute('SELECT * FROM $stTableName');
  }

  Future close() async{
    var db = await this.database;
    return db.close();
  }

}