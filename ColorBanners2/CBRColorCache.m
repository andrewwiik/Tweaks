#import "CBRColorCache.h"

#import "ColorBadges.h"
#import "Defines.h"

#import <objc/runtime.h>

#define DEFAULT_COUNT_LIMIT 100

static id bucket_Class = nil;
static id cb_Class = nil;
static BOOL prettierBanners_isInstalled = NO;

static void proxy_init() {
  static dispatch_once_t predicate;

  dispatch_once(&predicate, ^{
      bucket_Class = objc_getClass("CBRBucket");
      cb_Class = objc_getClass("ColorBadges");

      NSString *pBPath = @"/Library/MobileSubstrate/DynamicLibraries/PrettierBanners.dylib";
      prettierBanners_isInstalled = [[NSFileManager defaultManager] fileExistsAtPath:pBPath];
  });
}

static int proxy_colorForImage(UIImage *image) {
  proxy_init();

  if (bucket_Class) {
    return [bucket_Class colorForImage:image];
  }
  return [[cb_Class sharedInstance] colorForImage:image];
}

static BOOL proxy_isDarkColor(int color) {
  proxy_init();

  if (bucket_Class) {
    return [bucket_Class isDarkColor:color];
  }
  return [cb_Class isDarkColor:color];
}

@implementation CBRColorCache

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static CBRColorCache *cache;
  dispatch_once(&onceToken, ^{ cache = [[CBRColorCache alloc] init]; } );
  return cache;
}

+ (BOOL)isDarkColor:(int)color {
  return proxy_isDarkColor(color);
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _cache = [[NSCache alloc] init];
    [_cache setCountLimit:DEFAULT_COUNT_LIMIT];
  }
  return self;
}

- (int)colorForIdentifier:(NSString *)identifier image:(UIImage *)image {
  if (!identifier) {
    CBRLOG(@"No identifier given for image %@", image);
    return proxy_colorForImage(image);
  }
  if (prettierBanners_isInstalled && [identifier isEqualToString:@"com.apple.MobileSMS"]) {
    CBRLOG(@"PrettierBanners is installed! Avoiding the cache.");
    return proxy_colorForImage(image);
  }

  NSNumber *colorNum = [_cache objectForKey:identifier];
  if (colorNum) {
    CBRLOG(@"Cache hit for identifier %@", identifier);

    return [colorNum intValue];
  } else {
    CBRLOG(@"Cache miss for identifier %@", identifier);

    int color = proxy_colorForImage(image);
    [_cache setObject:@(color) forKey:identifier];
    return color;
  }
}

- (int)colorForImage:(UIImage *)image {
  if (!image) {
    CBRLOG(@"No image given when requesting analysis!");
  }
  return proxy_colorForImage(image);
}

- (void)dealloc {
  [_cache release];
  [super dealloc];
}

@end
