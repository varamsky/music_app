import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_app/models/db_playlist_model.dart';
import 'package:music_app/models/db_song_model.dart';
import 'package:music_app/providers/db_providers/playlist_db_provider.dart';
import 'package:music_app/providers/db_providers/pl_list_db_provider.dart';
import 'package:music_app/screens/playlist_screen.dart';
import 'package:music_app/screens/pl_list_screen.dart';
import 'package:music_app/screens/player_screen.dart';
import 'package:music_app/providers/music_data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final musicData = Provider.of<MusicData>(context, listen: false);
    final playlistDbProvider = Provider.of<PlaylistDbProvider>(context, listen: false);
    final plListDbProvider = Provider.of<PlListDbProvider>(context, listen: false);
    musicData.getSongs();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Music Player")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: musicData.songsList,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  return (snap.connectionState == ConnectionState.done)
                      ? Column(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              child: Scrollbar(
                                child: ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) => Divider(),
                                  itemCount: snap.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                PlayerScreen(
                                              songList: snap.data,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          child: (snap.data[index].albumArtwork ==
                                                  null)
                                              ? Image.asset(
                                                  'lib/assets/default_music_artwork.jpg',
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.file(
                                                  File(snap.data[index].albumArtwork),
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                      ),
                                      title: RichText(
                                        text: TextSpan(
                                          text: snap.data[index].title,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 18),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ), //Text(snap.data[index].title),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {},
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // TODO: Add database to keep track of last played song and to save playlists

                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => PlayerScreen(
                                        songList: snap.data,
                                        index: 15, //index,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 20.0,
                                  margin: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.keyboard_arrow_up),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PlayerScreen(
                                                songList: snap.data,
                                                index: 15, //index,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Current Song | Current Artist',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 18),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
            BottomNavigationBar(
              elevation: 10.0,
              currentIndex: 0,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.music_note),title: Text('Songs')),
                BottomNavigationBarItem(icon: Icon(Icons.playlist_play),title: Text('Playlists')),
              ],
              onTap: (int index) async{
                switch(index){
                  case 0:
                    print('songs tapped');
                    break;
                  case 1:
                    //print('checking pl button ${await favDbProvider.favPlDb.readSongs()}');
                    print('checking pl screen');
                    readPlaylistsFromDb(plListDbProvider,playlistDbProvider, context);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void readPlaylistsFromDb(PlListDbProvider plListDbProvider,PlaylistDbProvider playlistDbProvider,BuildContext context) async{
//    List<Map<String, dynamic>> map = await db.readSongs();

    List<Map<String, dynamic>> map = await plListDbProvider.plListDb.readPlaylists();

    print('NO. OF PLAYLISTS :: ${map.length}');

    map.forEach((element) {plListDbProvider.dbPlaylistList.add(DbPlaylistModel.fromMap(element));});

    Map<String, int> playlistSizeMap = Map<String, int>();

    for(int i=0;i<plListDbProvider.dbPlaylistList.length;i++){
      int size = await playlistDbProvider.playlistDb.getPlaylistSize(playlist: plListDbProvider.dbPlaylistList[i].dbName);
      playlistSizeMap[plListDbProvider.dbPlaylistList[i].dbName] = size;
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => PlListScreen(playlistList: plListDbProvider.dbPlaylistList,playlistSizeMap: playlistSizeMap,))).whenComplete(() => plListDbProvider.dbPlaylistList.clear());
  }
}
