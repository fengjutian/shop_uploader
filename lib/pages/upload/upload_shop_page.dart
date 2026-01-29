import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/shop_api.dart';
import '../../widgets/image_grid.dart';

class UploadShopPage extends StatefulWidget {
  const UploadShopPage({super.key});

  @override
  State<UploadShopPage> createState() => _UploadShopPageState();
}

class ShopItem {
  final String id;
  final String name;
  final String address;
  final List<String> imagePaths;

  ShopItem({
    required this.id,
    required this.name,
    required this.address,
    required this.imagePaths,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'imagePaths': imagePaths,
    };
  }

  factory ShopItem.fromMap(Map<String, dynamic> map) {
    return ShopItem(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      imagePaths: List<String>.from(map['imagePaths']),
    );
  }
}

class _UploadShopPageState extends State<UploadShopPage> {
  List<ShopItem> shops = [];
  String? _editingShopId;

  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  List<PickedImage> images = [];

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  Future<void> _loadShops() async {
    final prefs = await SharedPreferences.getInstance();
    final shopsJson = prefs.getString('shops');
    if (shopsJson != null) {
      final List<dynamic> shopsList = jsonDecode(shopsJson);
      setState(() {
        shops = shopsList.map((shop) => ShopItem.fromMap(shop)).toList();
      });
    }
  }

  Future<void> _saveShops() async {
    final prefs = await SharedPreferences.getInstance();
    final shopsList = shops.map((shop) => shop.toMap()).toList();
    final shopsJson = jsonEncode(shopsList);
    await prefs.setString('shops', shopsJson);
  }

  Future<void> _submitShop() async {
    if (!_formKey.currentState!.validate()) return;
    if (images.isEmpty) return;

    setState(() {
      if (_editingShopId != null) {
        // 编辑
        final index = shops.indexWhere((shop) => shop.id == _editingShopId);
        if (index != -1) {
          shops[index] = ShopItem(
            id: _editingShopId!,
            name: nameCtrl.text,
            address: addrCtrl.text,
            imagePaths: images.map((e) => e.file.path).toList(),
          );
        }
      } else {
        // 添加新店铺
        final newShop = ShopItem(
          id: DateTime.now().toString(),
          name: nameCtrl.text,
          address: addrCtrl.text,
          imagePaths: images.map((e) => e.file.path).toList(),
        );
        shops.add(newShop);

        // 上传到服务器
        Future(() async {
          try {
            await ShopApi.uploadShop(
              name: nameCtrl.text,
              address: addrCtrl.text,
              images: images.map((e) => e.file).toList(),
            );
          } catch (e) {
            print('上传失败: $e');
          }
        });
      }
    });

    // 保存本地
    await _saveShops();
  }

  Future<void> _showShopDialog({ShopItem? shop}) async {
    _editingShopId = shop?.id;
    nameCtrl.text = shop?.name ?? '';
    addrCtrl.text = shop?.address ?? '';
    images.clear();
    if (shop != null) {
      for (var path in shop.imagePaths) {
        images.add(PickedImage(File(path), DateTime.now().toString()));
      }
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          shop == null ? '添加店铺' : '编辑店铺',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            nameCtrl.clear();
                            addrCtrl.clear();
                            images.clear();
                            _editingShopId = null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: nameCtrl,
                              decoration: const InputDecoration(
                                labelText: '店铺名称',
                                hintText: '请输入店铺名称',
                              ),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? '请输入店铺名称' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: addrCtrl,
                              decoration: const InputDecoration(
                                labelText: '店铺地址',
                                hintText: '请输入店铺地址',
                              ),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? '请输入店铺地址' : null,
                            ),
                            const SizedBox(height: 16),
                            ImageGrid(
                              images: images,
                              onAdd: (image) =>
                                  setState(() => images.add(image)),
                              onRemove: (id) => setState(
                                () => images.removeWhere((img) => img.id == id),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TDButton(
                            text: '取消',
                            size: TDButtonSize.large,
                            type: TDButtonType.outline,
                            shape: TDButtonShape.rectangle,
                            theme: TDButtonTheme.primary,
                            onTap: () {
                              Navigator.of(context).pop();
                              nameCtrl.clear();
                              addrCtrl.clear();
                              images.clear();
                              _editingShopId = null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TDButton(
                            text: '保存',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            shape: TDButtonShape.rectangle,
                            theme: TDButtonTheme.primary,
                            onTap: () async {
                              if (!_formKey.currentState!.validate()) return;
                              if (images.isEmpty) {
                                TDToast.showText('请添加至少一张图片', context: context);
                                return;
                              }

                              try {
                                await _submitShop();
                                // 保存成功后关闭弹层
                                Navigator.pop(context);
                              } catch (e) {
                                print('保存店铺失败: $e');
                                TDToast.showText('保存失败', context: context);
                              } finally {
                                // 清空表单
                                nameCtrl.clear();
                                addrCtrl.clear();
                                images.clear();
                                _editingShopId = null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteShop(String id) async {
    setState(() {
      shops.removeWhere((shop) => shop.id == id);
    });
    await _saveShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('店铺管理')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TDButton(
              text: '添加店铺',
              size: TDButtonSize.large,
              type: TDButtonType.outline,
              shape: TDButtonShape.rectangle,
              theme: TDButtonTheme.primary,
              isBlock: true,
              onTap: () => _showShopDialog(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: shops.isEmpty
                  ? Center(
                      child: Text(
                        '暂无店铺数据',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        final shop = shops[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shop.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(shop.address),
                                const SizedBox(height: 12),
                                if (shop.imagePaths.isNotEmpty)
                                  SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: shop.imagePaths.length,
                                      itemBuilder: (context, imgIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: Image.file(
                                            File(shop.imagePaths[imgIndex]),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TDButton(
                                      text: '编辑',
                                      size: TDButtonSize.small,
                                      type: TDButtonType.outline,
                                      shape: TDButtonShape.rectangle,
                                      theme: TDButtonTheme.primary,
                                      onTap: () => _showShopDialog(shop: shop),
                                    ),
                                    const SizedBox(width: 8),
                                    TDButton(
                                      text: '删除',
                                      size: TDButtonSize.small,
                                      type: TDButtonType.outline,
                                      shape: TDButtonShape.rectangle,
                                      theme: TDButtonTheme.danger,
                                      onTap: () => _deleteShop(shop.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
