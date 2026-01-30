import 'package:flutter/material.dart';
import '../upload/upload_shop_page.dart';
import '../list/profile_page.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  int index = 0;

  final pages = const [UploadShopPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: '上传'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '列表'),
        ],
      ),
    );
  }
}
