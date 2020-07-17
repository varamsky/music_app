import 'package:flutter/cupertino.dart';
import 'package:music_app/databases/pl_list_db.dart';
import 'package:music_app/models/db_playlist_model.dart';

class PlListDbProvider with ChangeNotifier{
  final PlListDb plListDb = PlListDb();
  List<DbPlaylistModel> dbPlaylistList = List();


  initiateDb(){
    plListDb.initDb();
  }
}
