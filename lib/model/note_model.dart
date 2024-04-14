class NoteModel{
  int ?id;
  String title;
  String content;
  String createAt;
  String ?updateAt;


  NoteModel({this.id,  required this.title, required this.content,required this.createAt,  this.updateAt} );

  //create a method to convert the NoteModel object to a Map object
  Map <String,dynamic> toMap(){
    return ({
    "id": id,
    "title": title,
    "content": content,
    "createAt": createAt,
    "updateAt": updateAt,
    });
  }

  //create a method to convert the Map object to a NoteModel object
  factory NoteModel.fromMap(Map<String, dynamic> map){
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createAt: map['createAt'],
      updateAt: map['updateAt'],
    );
  }

  factory NoteModel.fromSqliteDatabase(Map<String, dynamic> map){
    return NoteModel(
      id: map['id']?.toInt()??0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createAt: map['createAt'] ,
      updateAt: map['updateAt'],
    );
  }
}