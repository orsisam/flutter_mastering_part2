// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Album {
  final int userId;
  final int id;
  final String title;
  Album({required this.userId, required this.id, required this.title});

  Album copyWith({int? userId, int? id, String? title}) {
    return Album(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'userId': userId, 'id': id, 'title': title};
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      userId: map['userId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Album(userId: $userId, id: $id, title: $title)';

  @override
  bool operator ==(covariant Album other) {
    if (identical(this, other)) return true;

    return other.userId == userId && other.id == id && other.title == title;
  }

  @override
  int get hashCode => userId.hashCode ^ id.hashCode ^ title.hashCode;
}

Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'title': title}),
  );

  debugPrint('${response.body}');

  if (response.statusCode == 201) {
    return Album.fromJson(response.body);
  } else {
    throw Exception('Failed to create album.');
  }
}
