import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_app/databases/db_songList.dart';
import 'package:music_app/model/model_Db_Song_Info.dart';
import 'package:music_app/screens/player_screen.dart';
import 'package:music_app/model/music_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int f = 0;

  MusicData musicData = MusicData();
  Future<List<ModelDbSongInfo>> _mySongs;//Future<List<SongInfo>> _mySongs;

  var db = DbSongList();

  @override
  void initState() {
    super.initState();
    //_mySongs = songs();
    _mySongs = musicData.findSongs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Music Player")),
        body: FutureBuilder(
          future: _mySongs,
          builder: (BuildContext context, AsyncSnapshot snap) {
            return (snap.connectionState == ConnectionState.done)
                ? ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => PlayerScreen(
                                currSong: snap.data[index],
                              ),
                            ),
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            child: Image.file(
                              File(snap.data[index].getStSongAlbumArtwork.toString()),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        title: Text(snap.data[index].getStSongTitle),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      );
                    },
                  )
                : CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
