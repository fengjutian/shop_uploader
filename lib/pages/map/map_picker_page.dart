import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_search/amap_flutter_search.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class MapPickerPage extends StatefulWidget {
  final Function(String, double, double) onSelectLocation;

  const MapPickerPage({super.key, required this.onSelectLocation});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late AMapController _mapController;
  LatLng? _selectedLatLng;
  String _selectedAddress = '';

  @override
  void initState() {
    super.initState();
    // 设置隐私合规
    AmapFlutterSearch.updatePrivacyAgree(true);
    AmapFlutterSearch.updatePrivacyShow(true, true);
    // 初始化AMap搜索
    AmapFlutterSearch.setApiKey(
      '5131350db8ad49230fd4c7f3cab4f1d8',
      '0716aaf97c763ed06d5935c51985a853',
    );
  }

  // 处理地图点击事件
  void _handleMapTap(LatLng latLng) {
    setState(() {
      _selectedLatLng = latLng;
    });
    // 进行逆地理编码，获取地址
    _getAddressFromLatLng(latLng);
  }

  // 根据经纬度获取地址
  void _getAddressFromLatLng(LatLng latLng) async {
    try {
      // 这里使用 AmapFlutterSearch 进行逆地理编码
      // 注意：amap_flutter_search 0.0.4 版本可能没有完整的逆地理编码功能
      // 实际项目中可能需要使用更高版本的 SDK 或其他方式实现

      // 模拟逆地理编码结果
      String address = '北京市朝阳区建国路88号';

      setState(() {
        _selectedAddress = address;
      });
    } catch (e) {
      print('获取地址失败: $e');
      setState(() {
        _selectedAddress = '获取地址失败';
      });
    }
  }

  // 确认选择
  void _confirmSelection() {
    if (_selectedLatLng != null && _selectedAddress.isNotEmpty) {
      widget.onSelectLocation(
        _selectedAddress,
        _selectedLatLng!.latitude,
        _selectedLatLng!.longitude,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Marker marker = Marker(
      position: _selectedLatLng ?? const LatLng(39.908722, 116.397496),
      icon: BitmapDescriptor.defaultMarker,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('选择地址'),
        actions: [
          TextButton(
            onPressed: _confirmSelection,
            child: const Text('确认', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AMapWidget(
              initialCameraPosition: const CameraPosition(
                target: LatLng(39.908722, 116.397496),
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onTap: _handleMapTap,
              markers: _selectedLatLng != null ? {marker} : {},
              apiKey: const AMapApiKey(
                androidKey: '5131350db8ad49230fd4c7f3cab4f1d8',
                iosKey: '0716aaf97c763ed06d5935c51985a853',
              ),
              privacyStatement: const AMapPrivacyStatement(
                hasContains: true,
                hasShow: true,
                hasAgree: true,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '选择的地址:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedAddress.isNotEmpty
                      ? _selectedAddress
                      : '请在地图上点击选择位置',
                ),
                if (_selectedLatLng != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '经纬度: ${_selectedLatLng!.latitude.toStringAsFixed(6)}, ${_selectedLatLng!.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
