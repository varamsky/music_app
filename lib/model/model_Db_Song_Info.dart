class ModelDbSongInfo{
  int _stSongId;
  String _stSongTitle;
  String _stSongTrack;
  String _stSongDuration;
  String _stSongFilePath;
  String _stSongAlbumArtwork;

  //DbSongInfo({_stSongId,this._stSongTitle,this._stSongTrack,this._stSongDuration,this.stSongFilePath});
  ModelDbSongInfo(this._stSongId,this._stSongTitle,this._stSongTrack,this._stSongDuration,this._stSongFilePath,this._stSongAlbumArtwork);

  int get getStSongId => this._stSongId;
  String get getStSongTitle => this._stSongTitle;
  String get getStSongTrack => this._stSongTrack;
  String get getStSongDuration => this._stSongDuration;
  String get getStSongFilePath => this._stSongFilePath;
  String get getStSongAlbumArtwork => this._stSongAlbumArtwork;

  set stSongAlbumArtwork(String value) {
    _stSongAlbumArtwork = value;
  }

  set stSongDuration(String value) {
    _stSongDuration = value;
  }

  set stSongTrack(String value) {
    _stSongTrack = value;
  }

  set stSongTitle(String value) {
    _stSongTitle = value;
  }

  set stSongId(int value) {
    _stSongId = value;
  }

  set stSongFilePath(String value) {
    _stSongFilePath = value;
  }


  Map<String,dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(_stSongId != null)
      map['ST_COL_ID'] = this._stSongId;


    map['ST_COL_TITLE'] = this._stSongTitle;
    map['ST_COL_TRACK'] = this._stSongTrack;
    map['ST_COL_DURATION'] = this._stSongDuration;
    map['ST_COL_FILE_PATH'] = this._stSongFilePath;
    map['ST_COL_ALBUM_ARTWORK'] = this._stSongAlbumArtwork;


    return map;
  }

  ModelDbSongInfo.map(dynamic obj){
    this._stSongId = obj['ST_COL_ID'];
    this._stSongTitle = obj['ST_COL_TITLE'];
    this._stSongTrack = obj['ST_COL_TRACK'];
    this._stSongDuration = obj['ST_COL_DURATION'];
    this._stSongFilePath = obj['ST_COL_FILE_PATH'];
    this._stSongAlbumArtwork = obj['ST_COL_ALBUM_ARTWORK'];
  }

  ModelDbSongInfo.fromMap(Map<dynamic,dynamic> map){
    this._stSongId = map['ST_COL_ID'];
    this._stSongTitle = map['ST_COL_TITLE'];
    this._stSongTrack = map['ST_COL_TRACK'];
    this._stSongDuration = map['ST_COL_DURATION'];
    this._stSongFilePath = map['ST_COL_FILE_PATH'];
    this._stSongAlbumArtwork = map['ST_COL_ALBUM_ARTWORK'];
  }

}