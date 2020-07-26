import 'package:flutter/material.dart';
import 'package:music_app/models/db_playlist_model.dart';
import 'package:music_app/models/db_song_model.dart';
import 'package:music_app/providers/db_providers/playlist_db_provider.dart';
import 'package:music_app/providers/db_providers/pl_list_db_provider.dart';
import 'package:music_app/screens/playlist_screen.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

class PlListScreen extends StatelessWidget {

  final List<DbPlaylistModel> playlistList;
  final Map<String,int> playlistSizeMap;

  PlListScreen({@required this.playlistList,@required this.playlistSizeMap});

  @override
  Widget build(BuildContext context) {
    final plListDbProvider = Provider.of<PlListDbProvider>(context, listen: false);
    final playlistDbProvider = Provider.of<PlaylistDbProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Playlist List Screen')),
        body: (playlistList.length == 0)?Center(child: Text('There are no Playlists.\nPlease create one.'),):ListView.builder(
          itemCount: playlistList.length,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
              leading: Icon(Icons.playlist_play),
              title: Text(playlistList[index].dbName),
              subtitle: Text('${playlistSizeMap[playlistList[index].dbName]} Songs'),
              onTap: (){
                readSongsFromDb(playlistDbProvider, context,playlistList[index].dbName);
              },
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10.0,
          currentIndex: 1,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.music_note),title: Text('Songs')),
            BottomNavigationBarItem(icon: Icon(Icons.playlist_play),title: Text('Playlists')),
          ],
          onTap: (int index) async{
            switch(index){
              case 0:
                print('songs tapped');
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()));
                //readSongsFromDb(favDbProvider, context);
                break;
              case 1:
                print('checking pl screen');
                break;
            }
          },
        ),
      ),
    );
  }

  void readSongsFromDb(PlaylistDbProvider playlistDbProvider,BuildContext context,String currPlaylist) async{
//    List<Map<String, dynamic>> map = await db.readSongs();

    //List<Map<String, dynamic>> map = await playlistDbProvider.playlistDb.readSongs();
    List<Map<String, dynamic>> map = await playlistDbProvider.playlistDb.readSongsFromPlaylist(playlist: currPlaylist);

    map.forEach((element) {
      playlistDbProvider.dbSongList.add(DbSongModel.fromMap(element));
      print('map item $element');
    });

    print('readSongs map : $map');
    print('favDbProvider.dbSongList : ${playlistDbProvider.dbSongList}');

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PlaylistScreen(songList: playlistDbProvider.dbSongList,))).whenComplete(() => playlistDbProvider.dbSongList.clear());
  }
}
