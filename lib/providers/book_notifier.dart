import 'package:flutibre_light/providers/book_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/book.dart';
import '../repository/database_handler.dart';

final bookNotifier = StateNotifierProvider((_) => BookNotifier());

class BookNotifier extends StateNotifier<BookState> {
  BookNotifier() : super(const BookState.initial()) {
    selectAll();
  }
  List<Book> books = [];

  void selectAll() async {
    var databaseHandler = DatabaseHandler();
    books = await databaseHandler.getBookItemList();
    state = state.copyWith(books: books);
  }

  Future insert({required Book book}) async {
    var databaseHandler = DatabaseHandler();

    await databaseHandler.insert(
      table: 'books',
      item: book,
    );
    selectAll();
  }

  Future<void> delete(int id) async {
    var databaseHandler = DatabaseHandler();
    await databaseHandler.delete('books', id);
    selectAll();
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
  }
}
