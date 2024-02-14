import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
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
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowMultiple: false,
          allowedExtensions: ['pdf', 'odt']);

      if (result != null) {
        _fileName = result!.files.first.name;
        pickedfile = result!.files.first;

        await saveFilePermanently(pickedfile);

        fileToDisplay = File(pickedfile!.path.toString());
        openFile(pickedfile!.path.toString());
      } else {
        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

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
            child: isLoading
                ? const CircularProgressIndicator()
                : pickedfile != null
                    ? Text(removeDiacritics(_fileName.toString()))
                    : const Text(''),
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

  void openFile(String path) {
    OpenFilex.open(path);
  }

  saveFilePermanently(PlatformFile? pickedfile) async {
    final newFile = File('/home/sire/${pickedfile!.name}');
    // ignore: avoid_print
    print(newFile.path.toString());
  }
}
