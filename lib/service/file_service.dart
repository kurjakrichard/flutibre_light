import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class FileService {
  void openFile(String path) {
    OpenFilex.open(path);
  }

  Future<File> addFile(PlatformFile? pickedfile) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile =
        File('${appStorage.path}/ebooks/${removeDiacritics(pickedfile!.name)}');
    return File(pickedfile.path!).copy(newFile.path);
  }
}
