// ignore_for_file: avoid_print, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';

import 'package:file_manager/providers/main_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class BaseProvider with ChangeNotifier {
  List<File> labaratoriesFiles = [];
  String uploadedPath = '';
  String uploadedPath2 = '';

  Future pickerLabaratoriesFile(BuildContext context) async {
    print('start uploading lab');
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    print(result!.paths.map((path) => File(path!)).toList());

    uploadedPath2 = result.paths.last!;
    // uploadedPath2.split('/').remove(uploadedPath2.split('/').last);
    print(uploadedPath2);

    if (result != null) {
      await Provider.of<CustomFileProvider>(context, listen: false).uploadFile(
        file: result.paths.map((path) => File(path!)).toList(),
        username: Provider.of<AuthProvider>(context, listen: false).userInfo!.displayName,
        fileName: 'labaratories',
      );
    }
    return 'done';
  }

  List<File> speechsFiles = [];
  Future pickerSpeechsFile(BuildContext context) async {
    print('start uploading speech');
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    print('${uploadedPath}nim');
    if (result != null) {
      Provider.of<CustomFileProvider>(context, listen: false).uploadFile(
        file: result.paths.map((path) => File(path!)).toList(),
        username: Provider.of<AuthProvider>(context, listen: false).userInfo!.displayName,
        fileName: 'speechs',
      );
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

  Future<List> getSpeechs() async {
    // List<Image1> images = [];
    Directory appDocDir = await getApplicationDocumentsDirectory();

    print('start getting speech');
    print(uploadedPath);
    ListResult user = await FirebaseStorage.instance.ref().child('speechs').listAll();

    for (Reference ref in user.items) {
      // String downloadPath = await ref.getDownloadURL();
      String filePath = '${appDocDir.path}/${ref.name}';
      print(filePath);
      File file = File(filePath);
      await ref.writeToFile(file);

      speechsFiles.add(file);
    }
    // notifyListeners();
    return speechsFiles;
  }

  Future<List> getLabaratories() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    // List<Image1> images = [];
    print('start getting lab');
    ListResult user = await FirebaseStorage.instance.ref().child('labaratories').listAll();
    for (Reference ref in user.items) {
      // String downloadPath = await ref.getDownloadURL();
      String filePath = '${appDocDir.path}/${ref.name}';
      print(filePath);
      File file = File(filePath);
      await ref.writeToFile(file);
      // String url = await ref.getDownloadURL();
      labaratoriesFiles.add(file);
    }
    notifyListeners();
    return labaratoriesFiles;
  }
}
