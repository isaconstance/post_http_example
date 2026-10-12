class Post {
  final int id;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'],
      body: map['body'],
    );
  }

  Map<String, dynamic> toMap(){
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'body': body});
    return result;
  }

  @override
  bool operator ==(Object other){
    if (identical(this, other)) return true;

    return other is Post &&
      other.id == id &&
      other.title == title &&
      other.body == body;
  }

  @override
  int get hashCode => Object.hash(id, title, body);

}




