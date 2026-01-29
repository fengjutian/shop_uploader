//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<amap_flutter_location/AMapFlutterLocationPlugin.h>)
#import <amap_flutter_location/AMapFlutterLocationPlugin.h>
#else
@import amap_flutter_location;
#endif

#if __has_include(<amap_flutter_map/AMapFlutterMapPlugin.h>)
#import <amap_flutter_map/AMapFlutterMapPlugin.h>
#else
@import amap_flutter_map;
#endif

#if __has_include(<amap_flutter_search/AmapFlutterSearchPlugin.h>)
#import <amap_flutter_search/AmapFlutterSearchPlugin.h>
#else
@import amap_flutter_search;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AMapFlutterLocationPlugin registerWithRegistrar:[registry registrarForPlugin:@"AMapFlutterLocationPlugin"]];
  [AMapFlutterMapPlugin registerWithRegistrar:[registry registrarForPlugin:@"AMapFlutterMapPlugin"]];
  [AmapFlutterSearchPlugin registerWithRegistrar:[registry registrarForPlugin:@"AmapFlutterSearchPlugin"]];
}

@end
