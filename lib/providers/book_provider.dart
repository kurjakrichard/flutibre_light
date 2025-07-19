import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book_notifier.dart';
import 'book_state.dart';

final booksProvider = StateNotifierProvider<BookNotifier, BookState>((ref) {
  return BookNotifier();
});
