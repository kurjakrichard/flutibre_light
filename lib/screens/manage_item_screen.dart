import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../model/book.dart';
import '../providers/booklist_provider.dart';

class ManageItemScreen extends StatefulWidget {
  const ManageItemScreen(
      {Key? key, required this.title, required this.buttonText})
      : super(key: key);
  final String title;
  final String buttonText;

  @override
  State<ManageItemScreen> createState() => _ManageItemScreenState();
}

class _ManageItemScreenState extends State<ManageItemScreen> {
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
              ? IconButton(
                  tooltip: 'Delete book',
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<BooksProvider>(context, listen: false)
                        .delete(selectedItem!.id!);
                    Navigator.pop(context);
                  },
                )
              : Container(),
        ],
      ),
      body: ListView(
        children: [
          textController('Title', _titleController),
          textController('AuthroSort', _author_sortController),
          textController('Path', _pathController),
          ElevatedButton(
              onPressed: () {
                Book book = Book(
                    id: selectedItem?.id,
                    title: _titleController.text,
                    author_sort: _author_sortController.text,
                    path: removeDiacritics(_pathController.text).toString());

                route != '/editpage'
                    ? Provider.of<BooksProvider>(context, listen: false)
                        .insert(book: book)
                    : Provider.of<BooksProvider>(context, listen: false)
                        .update(book: book, id: book.id!);
                //context.read<TodoProvider>().insertTodo(todo);

                Navigator.pop(context);
              },
              child: Text(widget.buttonText))
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
