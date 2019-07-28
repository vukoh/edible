//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <image_picker/ImagePickerPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <sqflite/SqflitePlugin.h>
#import <uni_links/UniLinksPlugin.h>
#import <url_launcher/UrlLauncherPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [UniLinksPlugin registerWithRegistrar:[registry registrarForPlugin:@"UniLinksPlugin"]];
  [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
}

@end
