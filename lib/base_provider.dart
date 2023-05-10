import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class BaseProvider with ChangeNotifier {
  List<File> labaratoriesFiles = [];

  Future pickerLabaratoriesFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      result.paths
          .map(
            (path) => labaratoriesFiles.add(
              File(path!),
            ),
          )
          .toList();
    }
    return 'done';
  }

  List<File> speechsFiles = [];
  Future pickerSpeechsFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      await result.paths.map((path) => speechsFiles.add(File(path!))).toList();
    }
    return 'done';
  }

  Future deleteSpeechsPath(File text) async {
    print(text);

    speechsFiles.remove(text);

    notifyListeners();
    return 'done';
  }

  Future deleteLabaratoriesPath(File text) async {
    labaratoriesFiles.remove(text);

    notifyListeners();
    return 'done';
  }
}
