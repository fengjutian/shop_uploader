import 'dart:io';
import 'package:dio/dio.dart';
import '../models/shop_model.dart';
import '../utils/device_util.dart';

class ShopApi {
  static final dio = Dio(BaseOptions(baseUrl: 'https://api.xxx.com'));

  static Future<void> uploadShop({
    required String name,
    required String address,
    required List<File> images,
  }) async {
    final deviceId = await DeviceUtil.getDeviceId();

    final form = FormData.fromMap({
      'name': name,
      'address': address,
      'deviceId': deviceId,
      'images': images.map((f) => MultipartFile.fromFileSync(f.path)).toList(),
    });

    await dio.post('/shop/upload', data: form);
  }

  static Future<List<ShopModel>> fetchMyShops() async {
    final deviceId = await DeviceUtil.getDeviceId();
    final res = await dio.get(
      '/shop/list',
      queryParameters: {'deviceId': deviceId},
    );
    return (res.data as List).map((e) => ShopModel.fromJson(e)).toList();
  }
}
