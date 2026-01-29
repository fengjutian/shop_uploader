import 'package:flutter/material.dart';
import '../../models/shop_model.dart';
import '../../services/shop_api.dart';

class ShopListPage extends StatelessWidget {
  const ShopListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('已上传')),
      body: FutureBuilder(
        future: ShopApi.fetchMyShops(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final list = snapshot.data! as List<ShopModel>;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(list[i].name),
              subtitle: Text(list[i].address),
            ),
          );
        },
      ),
    );
  }
}
