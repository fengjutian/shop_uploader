import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../models/shop_item.dart';

class ShopListItem extends StatelessWidget {
  final ShopItem shop;
  final Function(ShopItem) onEdit;
  final Function(String) onDelete;

  const ShopListItem({
    super.key,
    required this.shop,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
            if (shop.latitude != null && shop.longitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '经纬度: ${shop.latitude!.toStringAsFixed(6)}, ${shop.longitude!.toStringAsFixed(6)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
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
                  onTap: () => onEdit(shop),
                ),
                const SizedBox(width: 8),
                TDButton(
                  text: '删除',
                  size: TDButtonSize.small,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.danger,
                  onTap: () => onDelete(shop.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
