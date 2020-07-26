import 'package:flutter/cupertino.dart';
import 'package:music_app/databases/playlist_db.dart';
import 'package:music_app/models/db_song_model.dart';

class PlaylistDbProvider with ChangeNotifier{
  final PlaylistDb playlistDb = PlaylistDb();
  List<DbSongModel> dbSongList = List();

  initiateDb(){
    playlistDb.initDb();
  }

}
