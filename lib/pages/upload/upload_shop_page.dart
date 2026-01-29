import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
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
}

class _UploadShopPageState extends State<UploadShopPage> {
  List<ShopItem> shops = [];
  bool _isDialogVisible = false;

  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  List<PickedImage> images = [];

  void _showAddShopDialog() {
    setState(() {
      _isDialogVisible = true;
    });
  }

  void _hideAddShopDialog() {
    setState(() {
      _isDialogVisible = false;
      // 清空表单
      nameCtrl.clear();
      addrCtrl.clear();
      images.clear();
    });
  }

  Future<void> _submitShop() async {
    if (!_formKey.currentState!.validate()) return;
    if (images.isEmpty) return;

    // 模拟保存店铺信息
    final newShop = ShopItem(
      id: DateTime.now().toString(),
      name: nameCtrl.text,
      address: addrCtrl.text,
      imagePaths: images.map((e) => e.file.path).toList(),
    );

    // 添加到列表
    setState(() {
      shops.add(newShop);
    });

    // 关闭弹层
    _hideAddShopDialog();

    // 实际的 API 调用
    await ShopApi.uploadShop(
      name: nameCtrl.text,
      address: addrCtrl.text,
      images: images.map((e) => e.file).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('店铺管理')),
      body: Stack(
        children: [
          // 店铺列表
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 添加按钮
                TDButton(
                  text: '添加店铺',
                  size: TDButtonSize.large,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.primary,
                  isBlock: true,
                  onTap: _showAddShopDialog,
                ),
                const SizedBox(height: 16),

                // 店铺列表
                Expanded(
                  child: shops.isEmpty
                      ? Center(
                          child: Text(
                            '暂无店铺数据',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
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

          // 添加店铺弹层
          if (_isDialogVisible)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 600,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '添加店铺',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: _hideAddShopDialog,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Form(
                          key: _formKey,
                          child: Column(
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
                                  () =>
                                      images.removeWhere((img) => img.id == id),
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
                                      onTap: _hideAddShopDialog,
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
                                      onTap: _submitShop,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
