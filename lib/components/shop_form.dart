import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:amap_flutter_search/amap_flutter_search.dart';
import '../models/shop_item.dart';
import '../widgets/image_grid.dart';
import '../pages/map/map_picker_page.dart';

class ShopForm extends StatefulWidget {
  final ShopItem? shop;
  final Function(ShopItem) onSave;

  const ShopForm({super.key, this.shop, required this.onSave});

  @override
  State<ShopForm> createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  List<PickedImage> images = [];
  String? _editingShopId;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _editingShopId = widget.shop?.id;
    nameCtrl.text = widget.shop?.name ?? '';
    addrCtrl.text = widget.shop?.address ?? '';
    _latitude = widget.shop?.latitude;
    _longitude = widget.shop?.longitude;
    images.clear();
    if (widget.shop != null) {
      for (var path in widget.shop!.imagePaths) {
        images.add(PickedImage(File(path), DateTime.now().toString()));
      }
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    addrCtrl.dispose();
    super.dispose();
  }

  void _showAddressPicker() async {
    // 初始化AMap搜索
    AmapFlutterSearch.setApiKey(
      '5131350db8ad49230fd4c7f3cab4f1d8',
      '0716aaf97c763ed06d5935c51985a853',
    );

    // 导航到地图选择页面
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapPickerPage(
          onSelectLocation: (address, latitude, longitude) {
            // 在回调中更新地址和经纬度
            setState(() {
              addrCtrl.text = address;
              _latitude = latitude;
              _longitude = longitude;
            });
          },
        ),
      ),
    );
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    if (images.isEmpty) {
      TDToast.showText('请添加至少一张图片', context: context);
      return;
    }

    final shop = ShopItem(
      id: _editingShopId ?? DateTime.now().toString(),
      name: nameCtrl.text,
      address: addrCtrl.text,
      latitude: _latitude,
      longitude: _longitude,
      imagePaths: images.map((e) => e.file.path).toList(),
    );

    widget.onSave(shop);
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.shop == null ? '添加店铺' : '编辑店铺',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: addrCtrl,
                                decoration: const InputDecoration(
                                  labelText: '店铺地址',
                                  hintText: '请输入店铺地址',
                                ),
                                validator: (value) =>
                                    value?.isEmpty ?? true ? '请输入店铺地址' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            TDButton(
                              text: '选择地址',
                              size: TDButtonSize.small,
                              type: TDButtonType.outline,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                              onTap: _showAddressPicker,
                            ),
                          ],
                        ),
                        if (_latitude != null && _longitude != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '经纬度: ${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ImageGrid(
                      images: images,
                      onAdd: (image) => setState(() => images.add(image)),
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
                    onTap: () {
                      _handleSave();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
