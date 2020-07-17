import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:marquee/marquee.dart';
import 'package:music_app/databases/fav_pl_db.dart';
import 'package:music_app/models/db_playlist_model.dart';
import 'package:music_app/models/db_song_model.dart';
import 'package:music_app/providers/db_providers/fav_db_provider.dart';
import 'package:music_app/providers/db_providers/pl_list_db_provider.dart';
import 'package:music_app/providers/player_data.dart';
import 'package:music_app/screens/fav_pl_screen.dart';
import 'package:music_app/screens/queue_screen.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class PlayerControls extends StatefulWidget {
  final List<SongInfo> songList;
  int currIndex;

  //MusicControls({@required this.isPlay,@required this.assetsAudioPlayer});
  PlayerControls({@required this.songList, @required this.currIndex});

  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  String totalDuration;
  SongInfo currSong;

  @override
  void dispose() {
    super.dispose();

    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();
  }

//  FavPlDb db = FavPlDb(); // TODO: remove this from here
//  List<DbSongModel> dbSongList = List(); // TODO: remove this from here too

  @override
  Widget build(BuildContext context) {

//    db.initDb(); // TODO: remove this
    final plListDbProvider = Provider.of<PlListDbProvider>(context,listen: false);

    final favDbProvider = Provider.of<FavDbProvider>(context,listen: false);
    print('checking favDbProvider ${favDbProvider.favPlDb}');
    print('checking favDbProvider ${favDbProvider.favPlDb.readSongs()}');

    print('Inside PlayerControls build');
    final playerData = Provider.of<PlayerData>(context, listen: false);
    print('Inside PlayerControls build after provider instantiation');
    playerData.setCurrIndex = widget.currIndex;
    print(
        'widget.currIndex :: ${widget.currIndex} playerData.getCurrIndex :: ${playerData.getCurrIndex}');
    print('currSong ${widget.songList[playerData.getCurrIndex]}');
    currSong = widget.songList[playerData.getCurrIndex];
    totalDuration = currSong.duration;
    playerData.playSong(currSong, assetsAudioPlayer, totalDuration);
    properDuration();
    print('Inside PlayerControls build before return');

    return Center(
      child: Column( // TODO: Wrap with SingleChildScrollView to let the keyboard come up for the TextField without any error.
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //selector ensures that the widget is rebuild only when there is a change to PlayerData.currIndex
          Selector<PlayerData, int>(
            selector: (_, model) => model.currIndex,
            builder: (BuildContext context, int index, Widget widget) =>
                Container(
              width: 250.0,
              height: 250.0,
              //color: Colors.transparent,
              color: RandomColor().randomColor(),
              child: (currSong.albumArtwork == null)
                  ? Image.asset(
                      'lib/assets/default_music_artwork.jpg',
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(currSong.albumArtwork),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Selector<PlayerData, int>(
            selector: (_, model) => model.currIndex,
            builder: (BuildContext context, int index, Widget widget) =>
                Expanded(
                    child: Marquee(
                      blankSpace: 50.0,
                      text: currSong.title,
              style: TextStyle(color: Colors.black, fontSize: 25.0),
            )),
          ),
          /*Selector<PlayerData, int>(
            selector: (_, model) => model.currIndex,
            builder: (BuildContext context, int index, Widget widget) => Text(
              currSong.title,
              style: TextStyle(color: Colors.black, fontSize: 25.0),
            ),
          ),*/
          Selector<PlayerData, int>(
            selector: (_, model) => model.currIndex,
            builder: (BuildContext context, int index, Widget widget) =>
                Expanded(
              child: Marquee(
                blankSpace: 50.0,
                text: currSong.artist,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  if (playerData.getCurrIndex != 0) {
                    playerData.decreaseIndex();
                  }
                  playerData.isPlay = true;
                  //currIndex = playerData.getCurrIndex;
                  assetsAudioPlayer.stop();
                  playerData.sliderValue = 0.0;
                  currSong = widget.songList[playerData.getCurrIndex];
                  playerData.playSong(
                      currSong, assetsAudioPlayer, totalDuration);
                },
              ),
              Consumer<PlayerData>(
                builder: (BuildContext context, PlayerData playerData,
                        Widget widget) =>
                    IconButton(
                  icon: Icon(
                      (playerData.isPlay) ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    playerData.changeIsPlay();

                    assetsAudioPlayer.playOrPause();
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  if (playerData.getCurrIndex != (widget.songList.length - 1)) {
                    playerData.increaseIndex();
                  }
                  playerData.isPlay = true;
                  //currIndex = musicData.getCurrIndex;
                  assetsAudioPlayer.stop();
                  playerData.sliderValue = 0.0;
                  currSong = widget.songList[playerData.getCurrIndex];
                  playerData.playSong(
                      currSong, assetsAudioPlayer, totalDuration);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Consumer<PlayerData>(builder:
                  (BuildContext context, PlayerData playerData, Widget widget) {
                return Text(playerData.sliderDuration);
              }),
              Column(
                children: <Widget>[
                  Selector<PlayerData, double>(
                      selector: (_, model) => model.sliderValue,
                      builder: (BuildContext context, double sliderValue,
                          Widget consumerWidget) {
                        return Slider(
                          //TODO: update sliderValue as song plays
                          value: playerData
                              .sliderValue, // TODO: sliderValue changes but nothing observed on screen
                          min: 0.0,
                          max: double.parse(currSong.duration),
                          divisions: 100,
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          onChanged: (double value) {
                            playerData.sliderValue = value;
                            playerData.seekSlider(value, assetsAudioPlayer);
                          },
                        );
                      }),
                ],
              ),
              Consumer<PlayerData>(builder:
                  (BuildContext context, PlayerData playerData, Widget widget) {
                totalDuration = currSong.duration;
                properDuration();
                return Text(totalDuration);
              }),
            ],
          ),

          //TODO: remove this widget
          Container(
            width: 50.0,
            height: 50.0,
            //color: Colors.transparent,
            color: RandomColor().randomColor(),
            child: Text('test'),
          ),
          Row(
            children: <Widget>[
              Builder(
                builder: (BuildContext context){
                  return IconButton(
                    color: Colors.amber,
                    icon: Icon(Icons.favorite), // (isFav)?Icon(Icons.favorite):Icon(Icons.favorite_border),
                    tooltip: 'Add to Favorite',
                    onPressed: () {
                      // TODO: change this to use fav_db_provider
                      addSongToPlaylist(context,favDbProvider);
                    },
                  );
                },
              ),
              IconButton(
                color: Colors.amber,
                icon: Icon(Icons.queue_music),
                tooltip: 'Queue',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => QueueScreen(
                          queue: widget.songList, currIndex: widget.currIndex)));
                },
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert,color: Colors.amber,),
                tooltip: 'More',
                color: Colors.amber,
                onSelected: (String value){
                  print('$value selected');
                  switch(value){
                    case 'Add to playlist':
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text(value),
                            content: FutureBuilder(
                              future: plListDbProvider.plListDb.readPlaylists(),
                              builder: (BuildContext context, AsyncSnapshot snap){
                                return (snap.connectionState == ConnectionState.done)?ListView.builder(
                                  itemCount: snap.data.length,
                                  shrinkWrap: true, // shrinks size of list view else it takes up whole screen
                                  itemBuilder: (BuildContext context,int index){
                                    return ListTile(title: Text(snap.data[index]['dbName']),);
                                  },
                                ):Container();
                                //return ListTile(title: Text(snap.data['dbName'].toString()),);
                              },
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showNewPlaylistDialog();
                                },// TODO: implement this
                                child: Text('New Playlist'),
                              ),
                              RaisedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                      break;
                    case 'Settings':
                      break;
                  }
                },
                itemBuilder: (BuildContext context){
                  return {'Add to playlist', 'Settings'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*playSong(SongInfo songInfo) async {
    //final file = new File('${songInfo.filePath}');

    assetsAudioPlayer.open(
      Audio.file('${songInfo.filePath}'),
    );

    print('PATH :: ${songInfo.filePath}  PLAYING');
  }*/

  properDuration() {
    //For total Duration
    Duration duration = Duration(milliseconds: int.parse(totalDuration));
    String seconds, minutes, hours;

    seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    hours = duration.inHours.toString().padLeft(2, '0');

    totalDuration = (int.parse(hours) == 0)
        ? '$minutes:$seconds'
        : '$hours:$minutes:$seconds';
  }

  void addSongToPlaylist(BuildContext context,FavDbProvider favDbProvider) async{
    DbSongModel songToAdd = DbSongModel(id: int.parse(currSong.id),title: currSong.title,filePath: currSong.filePath,albumArtwork: currSong.albumArtwork);

//    int result = await db.insertSong(songToAdd.toMap());
    int result = await favDbProvider.favPlDb.insertSong(songToAdd.toMap());
    if(result != -1)
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Added song to Playlist')));
  }

  void showNewPlaylistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('New Playlist'),
          content: TextField( // TODO: use SingleChildScrollView to let the keyboard come up without any error.
            decoration: InputDecoration(
              hintText: 'New playlist name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(); // TODO: implement this

              },// TODO: implement this
              child: Text('CREATE'),
            ),
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }


  /*void readPlaylistsFromDb(PlListDbProvider plListDbProvider,BuildContext context) async{
//    List<Map<String, dynamic>> map = await db.readSongs();


    List<Map<String, dynamic>> map = await plListDbProvider.plListDb.readPlaylists();

    map.forEach((element) {plListDbProvider.dbPlaylistList.add(DbPlaylistModel.fromMap(element));});
  }*/

}
