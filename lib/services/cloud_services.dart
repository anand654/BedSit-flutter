import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:uuid/uuid.dart';

class CloudStorageServ {
  CloudStorageServ._privateConstructor();
  static final instance = CloudStorageServ._privateConstructor();
  final _storage = FirebaseStorage.instance;
  var uuid = Uuid();

  Future<String> uploadImage(File imageFile, String folder) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      imageFile.path,
      quality: 30,
    );
    try {
      Reference ref = _storage.ref().child("$folder/${uuid.v4()}.jpg");
      // Reference ref = _storage.ref().child(folder).child("${uuid.v4()}.jpg");
      await ref.putFile(compressedFile);
      var url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {}
  }
}
