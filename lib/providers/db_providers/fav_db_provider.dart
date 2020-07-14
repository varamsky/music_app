import 'package:flutter/cupertino.dart';
import 'package:music_app/databases/fav_pl_db.dart';
import 'package:music_app/models/db_song_model.dart';

class FavDbProvider with ChangeNotifier{
  final FavPlDb favPlDb = FavPlDb();
  List<DbSongModel> dbSongList = List();

  initiateDb(){
    favPlDb.initDb();
  }

}
