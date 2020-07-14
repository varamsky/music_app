class DbSongModel{

  final int id;
  final String title;
  final String filePath;
  final String albumArtwork;

  DbSongModel({this.id, this.title, this.filePath, this.albumArtwork});

  DbSongModel.fromMap(Map song):this.id=song['id'],this.title=song['title'],this.filePath=song['filePath'],this.albumArtwork=song['albumArt'];

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'albumArt': albumArtwork
    };
  }

}
