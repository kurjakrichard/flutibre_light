import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Book extends Equatable {
  int? id;
  final String title;
  // ignore: non_constant_identifier_names
  final String author_sort;
  final String path;

  // ignore: non_constant_identifier_names
  Book({this.id, this.title = '', this.author_sort = '', this.path = ''});

  //Convert a Map object to a model object
  @override
  Book.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        author_sort = res['author_sort'],
        path = res['path'];

  //Convert a model object to a Map opject
  Map<String, Object?> toMap() {
    return {'title': title, 'author_sort': author_sort, 'path': path};
  }

  @override
  String toString() {
    return 'Books(id : $id, title : $title, author_sort : $author_sort), path: $path';
  }

  @override
  List<Object?> get props => [title, author_sort, path];
}
