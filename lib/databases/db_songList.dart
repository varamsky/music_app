import 'dart:io';
import 'package:music_app/model/model_Db_Song_Info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbSongList {
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

  factory DbSongList() {
    if (_dbSongList == null) _dbSongList = DbSongList._createInstance();

    return _dbSongList;
  }

  Future<Database> get database async {
    if (_db == null) _db = await initDb();

    return _db;
  }

  Future<Database> initDb() async {
    String path =
        (await getApplicationDocumentsDirectory()).path + 'db_songs.db';

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return database;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $stTableName($stColId INTEGER PRIMARY KEY, $stColTitle TEXT, $stColTrack TEXT, $stColDuration TEXT, $stColFilePath TEXT, $stColAlbumArtwork TEXT)');
    print('\n\nTable $stTableName created\n\n');
    await db.execute('SELECT * FROM $stTableName');
  }

  // INSERT
  Future<int> saveSong(ModelDbSongInfo dbSongInfoModel) async {
    Directory directory = await getApplicationDocumentsDirectory();

    print('Directory path : ${directory.path}');

    var db = await this.database;

    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $stTableName'));
    print('Inside saveSong() count :: $count');
    /*for(int i=0;i<count;i++){
      List<Map<dynamic,dynamic>> dbIdMap = await db.rawQuery('SELECT $stColId FROM $stTableName');
      List l = dbIdMap.toList();
      print('l :: $l');
      int modelId = int.parse(dbSongInfoModel.getStSongId);
      print('modelId :: $modelId');
      bool isSame = int.parse(l[0]) == modelId;
      print('isSame :: $isSame');
      print('int.parse(l[0]) == modelId :: isSame');
      print('${int.parse(l[0])} == $modelId :: $isSame');

      if(!isSame){
        print('\nexecute INSERT\n');
        await db.execute('INSERT INTO $stTableName($stColId, $stColTitle, $stColTrack, $stColDuration) VALUES(\"${dbSongInfoModel.getStSongId}\", \"${dbSongInfoModel.getStSongTitle}\", \"${dbSongInfoModel.getStSongTrack}\", \"${dbSongInfoModel.getStSongDuration}\")');
      }

    }*/
    //int result = await db.insert(stTableName, dbSongInfoModel.toMap());
//    print('in saveSong() before execute');
//    print('SQL STATEMENT :: INSERT INTO $stTableName($stColId, $stColTitle, $stColTrack, $stColDuration, $stColFilePath) VALUES(\'${dbSongInfoModel.getStSongId}\', \'${dbSongInfoModel.getStSongTitle}\', \'${dbSongInfoModel.getStSongTrack}\', \'${dbSongInfoModel.getStSongDuration}\', \'${dbSongInfoModel.getStSongFilePath}\')');
//
//    //await db.execute('INSERT INTO $stTableName($stColId, $stColTitle, $stColTrack, $stColDuration, $stColFilePath) VALUES(\"${dbSongInfoModel.getStSongId}\", \"${dbSongInfoModel.getStSongTitle}\", \"${dbSongInfoModel.getStSongTrack}\", \"${dbSongInfoModel.getStSongDuration}\", \"${dbSongInfoModel.getStSongFilePath}\")');
//    await db.execute('INSERT INTO $stTableName($stColId, $stColTitle, $stColTrack, $stColDuration) VALUES(\"${dbSongInfoModel.getStSongId}\", \"${dbSongInfoModel.getStSongTitle}\", \"${dbSongInfoModel.getStSongTrack}\", \"${dbSongInfoModel.getStSongDuration}\")');
//    print('in saveSong() after execute');

    /*if(count == 0) {
      print('inside if(count == 0)');
      await db.execute(
          'INSERT INTO $stTableName($stColId, $stColTitle, $stColTrack, $stColDuration) VALUES(\"${dbSongInfoModel
              .getStSongId}\", \"${dbSongInfoModel
              .getStSongTitle}\", \"${dbSongInfoModel
              .getStSongTrack}\", \"${dbSongInfoModel.getStSongDuration}\")');
    }*/
    await db.execute(
        'INSERT INTO $stTableName($stColId, $stColTitle, $stColTrack, $stColDuration, $stColFilePath, $stColAlbumArtwork) VALUES(\"${dbSongInfoModel.getStSongId}\", \"${dbSongInfoModel.getStSongTitle}\", \"${dbSongInfoModel.getStSongTrack}\", \"${dbSongInfoModel.getStSongDuration}\", \"${dbSongInfoModel.getStSongFilePath}\", \"${dbSongInfoModel.getStSongAlbumArtwork}\")');
    int result = dbSongInfoModel.getStSongId;

    print('Insert result : ${result.toString()}');
    return result;
  }

  //GET
  Future<ModelDbSongInfo> getSong(int id) async {
    var db = await this.database;
    print('Inside DB getSong id : $id');
    var result =
        await db.rawQuery('SELECT * FROM $stTableName WHERE $stColId = $id');
    print('Inside DB getSong result : $result');
    print(
        'Inside DB getSong return  : ${ModelDbSongInfo.fromMap(result.first)}');
    return (result.length == 0) ? null : ModelDbSongInfo.fromMap(result.first);
  }

  Future<List<Map>> getAllSongs() async {
    var db = await this.database;

    List<Map> result = await db.rawQuery('SELECT * FROM $stTableName');

    // print the results
    /*print('\n\nPRINTING SQL TABLE :: \n\n');
    result.forEach((row) => print(row));*/
    return result;
  }

  Future<int> getCount() async {
    var db = await this.database;
    int result = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $stTableName'));
    return result;
  }

  void removeAll() async {
    var db = await this.database;
    db.execute('DELETE FROM $stTableName');
  }

  Future close() async {
    var db = await this.database;
    return db.close();
  }
}
