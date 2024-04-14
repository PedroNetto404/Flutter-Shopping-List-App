import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, Uint8List fileBytes, String mimeType) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putData(fileBytes, SettableMetadata(contentType: mimeType));

    await uploadTask;

    return await ref.getDownloadURL();
  }

  Future<Uint8List?> downloadFile(String url) async {
    final ref = _storage.refFromURL(url);
    final downloadUrl = await ref.getDownloadURL();

    return await _storage.refFromURL(downloadUrl).getData();
  }
}
