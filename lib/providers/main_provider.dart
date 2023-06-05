// import provider package
// ignore_for_file: unused_local_variable, avoid_print

import 'dart:io';

// import 'package:cross_file/cross_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../auth/firebase_options.dart';

// Image provider
class CustomFileProvider extends ChangeNotifier {
  FirebaseAuth auth;

  CustomFileProvider(this.auth);

  // get all image url from firebase storage

  // FirebaseStorage methods

  // FirebaseStorage methods
  Future<void> uploadFile({required List<File>? file, required String? username, required String fileName}) async {
    await Firebase.initializeApp(
      name: 'file_manage',
      options: const FirebaseOptions(
        apiKey: 'AIzaSyC1zZKBqkgFITtSlXvb6i53wlz_10_ObVA',
        appId: '1:887930857034:android:e9ff99f5c94a7b56e628b3',
        messagingSenderId: '887930857034',
        projectId: 'my-web-app-cc2b0',
        databaseURL: 'https://my-web-app-cc2b0-default-rtdb.firebaseio.com',
        storageBucket: 'my-web-app-cc2b0.appspot.com',
      ),
    );
    if (file == null) {
      throw Exception('No file was selected');
    }

    // get today's date
    print(fileName);
    // Create a Reference to the file
    for (var f in file) {
      Reference ref = FirebaseStorage.instance.ref().child(fileName).child(f.path.split('/').last);

      try {
        await ref.putFile(f);
      } catch (e) {
        throw Exception('File upload failed.');
      }
    }
    notifyListeners();
  }
}

// Auth provider
class AuthProvider extends ChangeNotifier {
  // firebase auth instance
  final FirebaseAuth _auth;

  AuthProvider(this._auth);

  // is login
  bool isLogin = false;
  User? userInfo;
  UserCredential? userCredential;

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());

      userCredential = result;
      User? user = result.user;
      isLogin = true;
      userInfo = user;
      notifyListeners();
      return user;
    } catch (e) {
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
      User? user = result.user;
      // update username
      await user!.updateDisplayName(username);
      return 'done';
    } catch (e) {
      return e;
    }
  }

  // sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      isLogin = false;
    } catch (e) {
      // write code that something went wrong
    }
  }

  // getter current user
  User get currentUser {
    return _auth.currentUser!;
  }
}
