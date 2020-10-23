import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:uuid/uuid.dart';

class ZImageCompress {
  static Future<String> uploadImgFireStorageFile({File imageFile}) async {
    var uuid = new Uuid();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('images').child("${uuid.v1()}.jpg");

    var uploadImg = await getCompressImageFile(imageFile);

    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(uploadImg);

    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;

    final String url = (await downloadUrl.ref.getDownloadURL());

    return url;
  }

  static Future<File> getCompressImageFile(File file) async {
    var uuid = new Uuid();
    var dir = await path_provider.getTemporaryDirectory();
    var targetPath = dir.absolute.path + uuid.v1() + '.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 600,
      minHeight: 600,
      rotate: 0,
    );
    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }
}
