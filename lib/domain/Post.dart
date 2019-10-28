import 'dart:collection';

class PostResponse {
  final int tPage;
  final List<Post> list;
  final int tCount;

  PostResponse({this.tPage, this.list, this.tCount});

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
        tPage: json['tPage'],
        list: (json['list'] as List)?.map((e) => e == null? null: new Post.fromJson(e as Map<String, dynamic>))?.toList(),
        tCount: json['tCount']
    );
  }
}

class Post {
  final int id;
  final String subject;
  final String regId;
  final String regDate;
  final String modifyDate;

  Post({this.id, this.subject, this.regId, this.regDate, this.modifyDate});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      subject: json['subject'],
      regId: json['regId'],
      regDate: json['regDate'],
      modifyDate: json['modifyDate'],
    );
  }
}