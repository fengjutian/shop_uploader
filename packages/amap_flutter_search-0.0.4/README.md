
##  前述 

1. 高德搜索Flutter插件
2. 登录[高德开放平台官网](https://lbs.amap.com/api/)分别申请[Android端](https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key/)和[iOS端](https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key)的key
3. 如需了解高德搜索原生SDK的相关功能，请参阅[Android搜索SDK开发指南](https://lbs.amap.com/api/android-sdk/guide/map-data/poi)和[iOS搜索SDK开发指南](https://lbs.amap.com/api/ios-sdk/guide/map-data/poi)


## 使用高德搜索Flutter插件
* 请参考[在Flutter里使用Packages](https://flutter.cn/docs/development/packages-and-plugins/using-packages)， 引入amap_flutter_search插件

#### 安卓端配置
需要将keystore文件添加到项目中，并在build.gradle中添加签名,(如需运行example中项目，需自行修改)
```
    signingConfigs {
        debug {
            storeFile file("xxx") //keystore路径
            storePassword 'xx'
            keyAlias 'xx'
            keyPassword 'xx'
        }
        release {
            storeFile file("xx") //keystore路径
            storePassword 'xx'
            keyAlias 'xx'
            keyPassword 'xx'
        }
    }

```



### 在需要的搜索功能的页面中引入搜索Flutter插件的dart类
``` Dart

import 'package:amap_flutter_search/amap_flutter_search.dart';
```
## 接口说明

### 设置Android和iOS的apikey
``` Dart
  ///设置Android和iOS的apikey，建议在weigdet初始化时设置<br>
  ///apiKey的申请请参考高德开放平台官网<br>
  ///Android端: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key<br>
  ///iOS端: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key<br>
  ///[androidKey] Android平台的key<br>
  ///[iosKey] ios平台的key<br>
  static void setApiKey(String androidKey, String iosKey)
```
> 隐私设置

``` Dart
  /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作<br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy<br>
  /// <b>必须保证在调用定位功能之前调用， 建议首次启动App时弹出《隐私政策》并取得用户同意</b><br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
  /// [hasContains] 隐私声明中是否包含高德隐私政策说明<br>
  /// [hasShow] 隐私权政策是否弹窗展示告知用户<br>
  static void updatePrivacyShow(bool hasContains, bool hasShow)

  /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作<br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy<br>
  /// <b>必须保证在调用定位功能之前调用, 建议首次启动App时弹出《隐私政策》并取得用户同意</b><br>
  /// [hasAgree] 隐私权政策是否已经取得用户同意<br>
  static void updatePrivacyAgree(bool hasAgree)
```
### 关键字搜索
``` Dart
  /// 关键字搜索poi
  ///
  /// 在城市[city]搜索关键字[keyword]的poi, 可以设置每页数量[pageSize](1-50)和第[page](1-100)页
  static Future<List<AMapPoi>> searchKeyword(
    String keyword, {
    String city = '',
    String types = '',
    int pageSize = 20,
    int page = 1,
  })
```
### 周边搜索poi
``` Dart
  /// 周边搜索poi
  ///
  /// 在中心点[center]周边搜索关键字[keyword]和城市[city]的poi, 可以设置每页数量[pageSize](1-50)和第[page](1-100)页
  static Future<List<AMapPoi>> searchAround(
    Location center, {
    String keyword ,
    String city ,
    int pageSize ,
    int page,
    int radius ,
  })
```
### TODO
``` Dart
  /// 输入内容自动提示
  ///
  /// 输入关键字[keyword], 并且限制所在城市[city]
  static Future<List> fetchInputTips(
    String keyword, {
    String city,
  })
```


### TODO
``` Dart
  /// 地理编码（地址转坐标）
  ///
  /// 输入关键字[keyword], 并且限制所在城市[city]
  static Future<List> searchGeocode(
    String keyword, {
    String city = '',
  })
```
