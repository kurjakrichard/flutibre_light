import 'package:flutibre_light/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import '../model/book.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.title, required this.buttonText});
  final String title;
  final String buttonText;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Book? selectedItem;
  final TextEditingController _titleController = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController _author_sortController = TextEditingController();
  final TextEditingController _pathController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _author_sortController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var routeSettings = ModalRoute.of(context)!.settings;
    final route = ModalRoute.of(context)?.settings.name;
    selectedItem = routeSettings.arguments as Book;
    _titleController.text = selectedItem?.title ?? '';
    _author_sortController.text = selectedItem?.author_sort ?? '';
    _pathController.text = selectedItem?.path ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          route == '/editpage'
              ? Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                  final booksState = ref.read(booksProvider.notifier);
                  return IconButton(
                    tooltip: 'Delete book',
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await booksState.delete(selectedItem!.id!);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                  );
                })
              : Container(),
        ],
      ),
      body: ListView(
        children: [
          textController('Title', _titleController),
          textController('AuthroSort', _author_sortController),
          textController('Path', _pathController),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final booksState = ref.read(booksProvider.notifier);
              return ElevatedButton(
                onPressed: () async {
                  Book book = Book(
                      id: selectedItem?.id,
                      title: _titleController.text,
                      author_sort: _author_sortController.text,
                      path: removeDiacritics(_pathController.text).toString());

                  route != '/editpage'
                      ? await booksState.insert(book: book)
                      : await booksState.update(book: book, id: book.id!);
                  //context.read<TodoProvider>().insertTodo(todo);

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: Text(widget.buttonText),
              );
            },
          ),
        ],
      ),
    );
  }

  String sortingAuthor(String author) {
    List<String> authorSplit = author.split(' ');
    String authorSort = authorSplit[authorSplit.length - 1];
    authorSplit.removeLast();
    for (var item in authorSplit) {
      authorSort = '$authorSort, $item';
    }
    return authorSort;
  }

  void clerControllers() {
    _titleController.clear();
    _author_sortController.clear();
    _pathController.clear();
  }

  Widget textController(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(), hintText: title),
      ),
    );
  }
}
