import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileHandler {
  static final FileHandler _fileHandlerSingleton = FileHandler._internal();

  FileHandler._internal();

  factory FileHandler() {
    return _fileHandlerSingleton;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeFile(String jsonData) async {
    final file = await _localFile;
    return file.writeAsString(jsonData);
  }
}
