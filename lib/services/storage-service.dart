import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  static StorageService? _instance;

  StorageService._();

  factory StorageService() {
    _instance ??= StorageService._();
    return _instance!;
  }

  Future<String> uploadFile(String path, Uint8List fileBytes, String contentType) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putData(fileBytes, SettableMetadata(contentType: contentType));

    await uploadTask;

    return await ref.getDownloadURL();
  }
}
