// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  Post({
    this.userId,
    this.id,
    this.title,
    this.body,
    this.date,
  });

  int? userId;
  int? id;
  String? title;
  String? body;
  DateTime? date;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
        "date": date.toString(),
      };
}

List<PostComment> postCommentFromJson(String str) => List<PostComment>.from(
    json.decode(str).map((x) => PostComment.fromJson(x)));

String postCommentToJson(List<PostComment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostComment {
  PostComment({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  int? postId;
  int? id;
  String? name;
  String? email;
  String? body;

  factory PostComment.fromJson(Map<String, dynamic> json) => PostComment(
        postId: json["postId"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "id": id,
        "name": name,
        "email": email,
        "body": body,
      };
}
