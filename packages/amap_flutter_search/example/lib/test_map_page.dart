/*
 * @Author: 丁健
 * @Date: 2022-04-01 16:03:54
 * @LastEditTime: 2022-04-01 16:03:55
 * @LastEditors: 丁健
 * @Description: 
 * @FilePath: /amap_flutter_search/example/lib/test_map_page.dart
 * 可以输入预定的版权声明、个性签名、空行等
 */

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';

class YZTestMapPage extends StatefulWidget {
  const YZTestMapPage({Key? key}) : super(key: key);

  @override
  State<YZTestMapPage> createState() => _YZTestMapPageState();
}

class _YZTestMapPageState extends State<YZTestMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: AMapWidget(),
      ),
    );
  }
}
