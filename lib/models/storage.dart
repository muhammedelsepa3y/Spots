import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<void>uploadFile({required String path, required String filename}) async {
    File file = File(path);
    try {
      await _storage.ref().child("${FirebaseAuth.instance.currentUser?.email}/$filename").putFile(file);
      print('File Uploaded');
    } on FirebaseException catch (e) {
      print(e.message);
    }

  }
  Future<String> downloadurl(String imageName) async {
    String downloadUrl = await _storage.ref().child("${FirebaseAuth.instance.currentUser?.email}/$imageName").getDownloadURL();
    return downloadUrl;
  }
}