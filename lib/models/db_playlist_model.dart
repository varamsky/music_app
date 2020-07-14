class DbPlaylistModel{

  final int id;
  final String dbName;

  DbPlaylistModel({this.id, this.dbName});

DbPlaylistModel.fromMap(Map playlist):this.id=playlist['id'],this.dbName=playlist['dbName'];

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'dbName': dbName
    };
  }

}
