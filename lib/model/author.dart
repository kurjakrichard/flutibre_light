import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Author extends Equatable {
  int? id;
  final String name;
  final String sort;

  Author({this.id, required this.name, this.sort = ''});

  //Convert a Map object to a model object
  @override
  Author.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        sort = res['sort'];

  //Convert a model object to a Map opject
  Map<String, Object?> toMap() {
    return {'name': name, 'sort': sort};
  }

  @override
  String toString() {
    return 'Books(id : $id, name : $name, sort : $sort)';
  }

  @override
  List<Object?> get props => [name, sort];
}
