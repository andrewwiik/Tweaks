//
//  BTOShortCutManager.m
//  test
//
//  Created by Brian Olencki on 10/17/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "BTOShortCutManager.h"
#import <UIKit/UIKit.h>

#define PREF_OPTIONS_KEY (@"shortCuts")
#define FILE_PATH (@"/var/mobile/Library/Preferences/com.bolencki13.customft-applicationList.plist")

@implementation BTOShortCutManager
@synthesize delegate = _delegate;
+ (BTOShortCutManager*)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
- (id)init {
    if (self == [super init]) {

    }
    return self;
}

#pragma mark - Public Functions
- (NSDictionary*)getShortCuts {
    [self checkAndCreate];
    NSDictionary *savedValue = [[NSDictionary alloc] initWithContentsOfFile:FILE_PATH];

    return savedValue;
}
- (void)deleteShortCutWithBundleID:(NSString *)bundleID {
    NSMutableDictionary *dictShortCuts = [[self getShortCuts] mutableCopy];
    NSArray *listItems = [bundleID componentsSeparatedByString:@"-"];
    NSString *identifier = [listItems objectAtIndex:0];
    NSString *title = [listItems objectAtIndex:([listItems count]-1)];

    NSMutableArray *item = [[dictShortCuts objectForKey:identifier] mutableCopy];

    if ([item count] == 1) {
      [dictShortCuts removeObjectForKey:identifier];
    } else {
      for (NSMutableArray *objects in item) {
            if ([objects containsObject:title]) {
              [item removeObject:objects];
              [dictShortCuts setObject:item forKey:identifier];
              break;
            }
      }
    }
    [dictShortCuts writeToFile:FILE_PATH atomically:YES];
}
- (void)addShortCutWithTitle:(NSString *)title withSubTitle:(NSString *)subTitle withBundleID:(NSString *)bundleID withURL:(NSString*)url withIcon:(NSInteger)iconNumber withImage:(NSString*)image {
    if ([title isEqualToString:@""] || [bundleID isEqualToString:@""]) {
        return;
    }
    if ([subTitle isEqualToString:@""]) {
      subTitle = @"*ignore*";
    }

    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:FILE_PATH];
    NSArray *currentItems = [[NSArray alloc] initWithObjects:title,subTitle,bundleID, url, [NSNumber numberWithInt:iconNumber], image, nil];

    if ([data objectForKey:bundleID]) {
        NSMutableArray *aryDictItem = [[data objectForKey:bundleID] mutableCopy];
        [aryDictItem addObject:currentItems];
        [data setObject:aryDictItem forKey:bundleID];
    } else {
        NSMutableArray *aryDictItem = [[NSMutableArray alloc] initWithObjects:currentItems, nil];
        [data setObject:aryDictItem forKey:bundleID];
    }
    NSLog(@"%@",[data writeToFile:FILE_PATH atomically:YES] ? @"YES" : @"NO");
}
- (NSArray*)shortCutsForAppWithBundleID:(NSString*)bundleID {
    NSDictionary *tempDict = [self getShortCuts];

    if ([tempDict objectForKey:bundleID]) {
     return (NSArray*)[tempDict objectForKey:bundleID];
   }
   return nil;
 }
- (NSString*)getURLSchemeForBundleID:(NSString*)bundleID withTitle:(NSString*)title {
  NSDictionary *tempDict = [self getShortCuts];
  NSArray *bundleList = (NSArray*)[tempDict objectForKey:bundleID];

  NSString *url = @"";
  for (NSArray *aryTemp in bundleList) {
    if ([aryTemp containsObject:title]) {
      url = [aryTemp objectAtIndex:3];
      break;
    }
  }

  return url;
}
- (BOOL)containsBundleID:(NSString*)bundleID {
  NSDictionary *tempDict = [self getShortCuts];
  if ([tempDict objectForKey:bundleID]) {
    return YES;
  } else {
    return NO;
  }
}
- (UIApplicationShortcutIconType)iconTypeForNumber:(NSInteger)number {
  switch (number) {
      case 0:
          return UIApplicationShortcutIconTypeAdd;
          break;
//        case 1:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAlarm]];
//            break;
//        case 2:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAudio]];
//            break;
//        case 3:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeBookmark]];
//            break;
//        case 4:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCapturePhoto]];
//            break;
//        case 5:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCaptureVideo]];
//            break;
//        case 6:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCloud]];
//            break;
      case 1:
          return UIApplicationShortcutIconTypeCompose;
          break;
//        case 8:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeConfirmation]];
//            break;
//        case 9:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeContact]];
//            break;
//        case 10:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeDate]];
//            break;
//        case 11:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeFavorite]];
//            break;
//        case 12:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeHome]];
//            break;
//        case 13:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeInvitation]];
//            break;
      case 2:
          return UIApplicationShortcutIconTypeLocation;
          break;
//        case 15:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLove]];
//            break;
//        case 16:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeMail]];
//            break;
//        case 17:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeMarkLocation]];
//            break;
//        case 18:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeMessage]];
//            break;
      case 3:
          return UIApplicationShortcutIconTypePause;
          break;
      case 4:
          return UIApplicationShortcutIconTypePlay;
          break;
//        case 21:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeProhibit]];
//            break;
      case 5:
          return UIApplicationShortcutIconTypeSearch;
          break;
      case 6:
          return UIApplicationShortcutIconTypeShare;
          break;
//        case 24:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShuffle]];
//            break;
//        case 25:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeTask]];
//            break;
//        case 26:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeTaskCompleted]];
//            break;
//        case 27:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeTime]];
//            break;
//        case 28:
//            [self setFTActionWithIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeUpdate]];
//            break;
      default:
          return UIApplicationShortcutIconTypeAdd;
          break;
  }
}
- (NSData*)customImageForBundleID:(NSString*)bundleID withTitle:(NSString*)title {
  NSDictionary *tempDict = [self getShortCuts];
  NSArray *bundleList = (NSArray*)[tempDict objectForKey:bundleID];

  NSString *imageURL;
  for (NSArray *aryTemp in bundleList) {
    if ([aryTemp containsObject:title]) {
      imageURL = [aryTemp objectAtIndex:5];
      break;
    }
  }
  NSData *imageData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:@"/Library/Application Support/CustomFT/kCustomFT.bundle/respring.png"]);

  return imageData;
}
- (NSArray*)itemForBundleID:(NSString*)bundleID withTitle:(NSString*)title {
  NSDictionary *tempDict = [self getShortCuts];
  NSArray *bundleList = (NSArray*)[tempDict objectForKey:bundleID];

  NSArray *item;
  for (NSArray *aryTemp in bundleList) {
    if ([aryTemp containsObject:title]) {
      item = aryTemp;
      break;
    }
  }

  return item;
}

#pragma mark - Private Functions
- (void)checkAndCreate {
  NSFileManager *fileManager = [NSFileManager defaultManager];

  if (![fileManager fileExistsAtPath:FILE_PATH]){
    NSMutableDictionary *data = [NSMutableDictionary new];

    NSArray *test = [[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"Test-Tittle",@"Test-SubTittle",@"Test-BundleID",@"Test-URL_Scheme",@"Test-Icon#",@"Test-Icon_URL", nil], nil];
    [data setObject:test forKey:@"com.bolencki13.test-ShortCut"];

    NSArray *respring = [[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"Respring",@"Respring Device",@"com.apple.Preferences",@"respring",@"0",@"", nil], nil];
    [data setObject:respring forKey:@"com.apple.Preferences"];

    [data writeToFile:FILE_PATH atomically:YES];
  }
}
@end
