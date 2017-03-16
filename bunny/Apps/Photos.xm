@interface DCIMImageWellUtilities : NSObject
+ (id)cameraPreviewWellImage;
+ (id)cameraPreviewWellImageFileURL;
@end

@interface PLQuickActionManager : NSObject
+ (instancetype)sharedManager;
-(void)_setCachedMostRecentPhotoData:(id)arg1;
- (id)_buildMostRecentPhotoQuickAction;
@end


%hook PhotosApplication // Photos Application
/*
- (id)init {
  %orig;

  NSURL *lastImageURL = [%c(DCIMImageWellUtilities) cameraPreviewWellImageFileURL];
  NSData *imageData = [[NSData alloc] initWithContentsOfURL:lastImageURL];
  PLQuickActionManager *qActionManager = [%c(PLQuickActionManager) sharedManager];
  [qActionManager _setCachedMostRecentPhotoData:imageData];
  // [qActionManager _setMostRecentPhotoIsInvalid:NO];

  SBSApplicationShortcutCustomImageIcon *recentSbsIcon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:imageData];
  UIApplicationShortcutIcon *recentIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon:recentSbsIcon];
  UIApplicationShortcutIcon *favoruIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"QuickActionFavorite-OrbHW"];
  UIApplicationShortcutIcon *onYearIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"QuickActionAYearAgo-OrbHW"];

  UIMutableApplicationShortcutItem *recent = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.photos.shortcuts.recentphoto" localizedTitle:@"MOST_RECENT_PHOTO" localizedSubtitle:nil icon:recentIcon userInfo:nil];
  UIMutableApplicationShortcutItem *favorite = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.photos.shortcuts.favorites" localizedTitle:@"FAVORITES" localizedSubtitle:nil icon:favoruIcon userInfo:nil];
  UIMutableApplicationShortcutItem *yearago = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.photos.shortcuts.oneyearago" localizedTitle:@"ONE_YEAR_AGO" localizedSubtitle:nil icon:onYearIcon userInfo:nil];
  UIMutableApplicationShortcutItem *search = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.photos.shortcuts.search" localizedTitle:@"SEARCH" localizedSubtitle:nil icon:[[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch]] userInfo:nil];
  [[UIApplication sharedApplication] setShortcutItems: @[ recent, favorite, yearago, search ]];
  return %orig;
}
*/
%end

%ctor {
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.mobileslideshow"]) { // Photos App
          %init;
  }
}