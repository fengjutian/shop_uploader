import 'package:flutter/material.dart';
import 'pages/home/home_tab_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '店铺上传',
      theme: ThemeData(useMaterial3: true),
      home: const HomeTabPage(),
    );
  }
}
