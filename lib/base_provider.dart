import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseProvider with ChangeNotifier {
  List<File>? files;
  pickerFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<Permission, PermissionStatus> status = await [
      Permission.storage,
    ].request();
    if (!status[Permission.storage]!.isDenied) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        files = result.paths.map((path) => File(path!)).toList();
      }
    } else {
      Permission.storage.request();
    }
    prefs.setStringList('file_paths', (files ?? []).map((e) => (e.path).split('/')[(e.path).split('/').length - 1]) as List<String>);
  }

  List<String?> get paths => (files ?? []).map((file) => kIsWeb ? throw UnsupportedError('Picking paths is unsupported on Web. Please, use bytes property instead.') : file.path).toList();
}
