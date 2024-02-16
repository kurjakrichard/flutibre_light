import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

void main() {
  runApp(const Flutibre());
}

class Flutibre extends StatelessWidget {
  const Flutibre({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutibre'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PlatformFile? _pickedfile;
  bool _isLoading = false;
  var allowedExtensions = ['pdf', 'odt', 'epub', 'mobi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _pickedfile != null
                    ? Text(removeDiacritics(_pickedfile!.name.toString()))
                    : const Text('Nincs fájl.'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void pickFile() async {
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
        print('Name: ${_pickedfile!.name}');
        print('Bytes: ${_pickedfile!.bytes}');
        print('Size: ${_pickedfile!.size}');
        print('Extension: ${_pickedfile!.extension}');
        print('Path: ${_pickedfile!.path}');

        await saveFilePermanently(_pickedfile);

        openFile(_pickedfile!.path!);
      } else {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void openFile(String path) {
    OpenFilex.open(path);
  }

  Future<File> saveFilePermanently(PlatformFile? pickedfile) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile =
        File('${appStorage.path}/${removeDiacritics(pickedfile!.name)}');
    return File(pickedfile.path!).copy(newFile.path);
  }
}
