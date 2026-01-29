import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageUtil {
  static final ImagePicker _picker = ImagePicker();
  static const Uuid _uuid = Uuid();

  /// 拍照并压缩图片
  static Future<File?> pickAndCompress() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (picked == null) return null;

    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/${_uuid.v4()}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      picked.path,
      targetPath,
      quality: 70,
    );

    // 确保返回 File 类型
    return result != null ? File(result.path) : null;
  }
}
