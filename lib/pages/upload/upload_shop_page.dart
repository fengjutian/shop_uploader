import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/shop_api.dart';
import '../../models/shop_item.dart';
import '../../components/shop_form.dart';
import '../../components/shop_list_item.dart';

class UploadShopPage extends StatefulWidget {
  const UploadShopPage({super.key});

  @override
  State<UploadShopPage> createState() => _UploadShopPageState();
}

class _UploadShopPageState extends State<UploadShopPage> {
  List<ShopItem> shops = [];

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

  Future<void> _handleSaveShop(ShopItem shop) async {
    setState(() {
      final index = shops.indexWhere((s) => s.id == shop.id);
      if (index != -1) {
        // 编辑现有店铺
        shops[index] = shop;
      } else {
        // 添加新店铺
        shops.add(shop);

        // 上传到服务器
        Future(() async {
          try {
            await ShopApi.uploadShop(
              name: shop.name,
              address: shop.address,
              latitude: shop.latitude,
              longitude: shop.longitude,
              images: shop.imagePaths.map((path) => File(path)).toList(),
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

  Future<void> _showAddShopDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShopForm(onSave: _handleSaveShop);
      },
    );
  }

  Future<void> _showEditShopDialog(ShopItem shop) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShopForm(shop: shop, onSave: _handleSaveShop);
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
                        return ShopListItem(
                          shop: shop,
                          onEdit: _showEditShopDialog,
                          onDelete: _deleteShop,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: TDFab(
        theme: TDFabTheme.primary,
        size: TDFabSize.large,
        shape: TDFabShape.square,
        text: '添加店铺',
        icon: const Icon(Icons.add, color: Colors.white),
        onClick: _showAddShopDialog,
      ),
    );
  }
}
