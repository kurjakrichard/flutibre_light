import 'package:flutter/foundation.dart';
import '../model/book.dart';
import '../repository/database_handler.dart';

class BooksProvider extends ChangeNotifier {
  List<Book> items = [];

  Future<void> selectAll() async {
    var databaseHandler = DatabaseHandler();
    items = await databaseHandler.getBookItemList();

    notifyListeners();
  }

  Future insert({required Book book}) async {
    var databaseHandler = DatabaseHandler();

    await databaseHandler.insert(
      table: 'books',
      item: book,
    );
    selectAll();
    notifyListeners();
  }

  void delete(int id) async {
    var databaseHandler = DatabaseHandler();
    await databaseHandler.delete('books', id);
    selectAll();
    notifyListeners();
  }

  Future update({
    required Book book,
    required int id,
  }) async {
    var databaseHandler = DatabaseHandler();
    databaseHandler.update(
      table: 'books',
      id: id,
      item: book,
    );
    selectAll();
    notifyListeners();
  }
}
