import 'package:file_picker/file_picker.dart';
import 'package:flutibre_light/providers/book_provider.dart';
import 'package:flutibre_light/service/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import '../model/book.dart';
import '../repository/database_handler.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Book? selectedBook;
  PlatformFile? _pickedfile;
  // ignore: unused_field
  bool _isLoading = false;
  FileService fileService = FileService();
  var allowedExtensions = ['pdf', 'odt', 'epub', 'mobi'];

  @override
  Widget build(BuildContext context) {
    var bookState = ref.watch(booksProvider);
    var routeSettings = ModalRoute.of(context)!.settings;
    if (routeSettings.arguments != null) {
      selectedBook = routeSettings.arguments as Book;
    }
    return Scaffold(
        appBar: AppBar(title: const Text('Flutibre')),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () async {
            Book? newBook = await pickFile();
            if (newBook != null) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamed('/addpage', arguments: newBook);
            }
          },
        ),
        body: bookState.books.isNotEmpty
            ? ListView.builder(
                itemCount: bookState.books.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      onTap: () async {
                        var databaseHandler = DatabaseHandler();
                        selectedBook = await databaseHandler.selectItemById(
                          bookState.books[index].id!,
                          'books',
                        ) as Book;

                        if (!context.mounted) return;
                        Navigator.of(context)
                            .pushNamed('/editpage', arguments: selectedBook);
                        //provider.delete(provider.items[index]);
                      },
                      style: ListTileStyle.drawer,
                      title: Text(bookState.books[index].title),
                      subtitle: Text(bookState.books[index].author_sort),
                      trailing: Text(bookState.books[index].path),
                    ),
                  );
                })
            : const Center(
                child: Text(
                  'List has no data',
                  style: TextStyle(fontSize: 35, color: Colors.black),
                ),
              ));
  }

  Future<Book?> pickFile() async {
    Book? newBook;
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: allowedExtensions);

      if (result != null) {
        _pickedfile = result.files.first;
        // ignore: avoid_print
        print('Name: ${_pickedfile!.name}');
        // ignore: avoid_print
        print('Bytes: ${_pickedfile!.bytes}');
        // ignore: avoid_print
        print('Size: ${_pickedfile!.size}');
        // ignore: avoid_print
        print('Extension: ${_pickedfile!.extension}');
        // ignore: avoid_print
        print('Path: ${_pickedfile!.path}');
        newBook = Book(path: removeDiacritics(_pickedfile!.name.toString()));
        await fileService.addFile(_pickedfile);
        //fileService.openFile(_pickedfile!.path!);
      } else {
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return newBook;
  }
}
