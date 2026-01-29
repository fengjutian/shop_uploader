import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageUtil {
  static final ImagePicker _picker = ImagePicker();
  static const Uuid _uuid = Uuid();

  /// 拍照、美化并压缩图片
  static Future<File?> pickAndEnhanceImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (picked == null) return null;

    // 读取图片文件
    final imageBytes = await picked.readAsBytes();

    // 美化图片
    final enhancedImage = await _enhanceImage(imageBytes);

    // 压缩图片
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/${_uuid.v4()}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      enhancedImage.path,
      targetPath,
      quality: 70,
    );

    // 确保返回 File 类型
    return result != null ? File(result.path) : null;
  }

  /// 美化图片
  static Future<File> _enhanceImage(Uint8List imageBytes) async {
    // 解码图片
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // 调整亮度、对比度和饱和度
    final enhanced = img.adjustColor(
      image,
      brightness: 0.1, // 增加10%亮度
      contrast: 1.2, // 增加20%对比度
      saturation: 1.1, // 增加10%饱和度
    );

    // 应用轻微锐化
    final sharpened = img.unsharpMask(enhanced, radius: 2, amount: 0.5);

    // 保存美化后的图片
    final dir = await getTemporaryDirectory();
    final tempPath = '${dir.path}/${_uuid.v4()}_enhanced.jpg';

    final enhancedBytes = img.encodeJpg(sharpened, quality: 95);
    await File(tempPath).writeAsBytes(enhancedBytes);

    return File(tempPath);
  }

  /// 拍照并压缩图片（兼容旧方法）
  static Future<File?> pickAndCompress() async {
    return pickAndEnhanceImage();
  }
}
