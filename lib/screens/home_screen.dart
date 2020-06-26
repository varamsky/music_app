import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_app/screens/player_screen.dart';
import 'package:music_app/model/music_data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final musicData = Provider.of<MusicData>(context, listen: false);
    musicData.getSongs();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Music Player")),
        body: FutureBuilder(
          future: musicData.songsList,
          builder: (BuildContext context, AsyncSnapshot snap) {
            return (snap.connectionState == ConnectionState.done)
                ? Scrollbar(
                  child: ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => PlayerScreen(
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
                              child: (snap.data[index].albumArtwork == null)?Image.asset('lib/assets/default_music_artwork.jpg',fit: BoxFit.fill,):Image.file(
                                File(snap.data[index].albumArtwork),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          title: Text(snap.data[index].title),
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
                )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
