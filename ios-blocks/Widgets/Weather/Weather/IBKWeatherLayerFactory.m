//
//  IBKWeatherLayerFactory.m
//  Weather
//
//  Created by Matt Clarke on 24/03/2015.
//
//

#import "IBKWeatherLayerFactory.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface CAMLParser : NSObject
@property (weak) IBKWeatherLayerFactory *delegate;
@property(readonly) id result;
@property(retain) NSURL * baseURL;
@property(readonly) NSError * error;
+ (id)parser;
+ (id)parseContentsOfURL:(id)arg1;
- (bool)parseContentsOfURL:(id)arg1;
@end

@interface UIImage (Private)
+ (UIImage*)imageWithContentsOfCPBitmapFile:(id)arg1 flags:(int)arg2;
@end

static IBKWeatherLayerFactory *shared;

@implementation IBKWeatherLayerFactory

+(instancetype)sharedInstance {
    if (!shared) {
        shared = [[IBKWeatherLayerFactory alloc] init];
    }
    
    return shared;
}

-(id)init {
    self = [super init];
    
    if (self) {
        self.weatherFrameworkBundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Weather.framework"];
    }
    
    return self;
}

- (id)layerForCondition:(int)arg1 isDay:(_Bool)arg2 withLargestSizePossible:(BOOL)largest {
    CAMLParser *parser = [CAMLParser parser];
    parser.delegate = self;
    parser.baseURL = [NSURL URLWithString:@"file:///System/Library/PrivateFrameworks/Weather.framework/"];
    
    NSURL *url = [self filenameForCondition:arg1 isDay:arg2 largest:largest];
    
    NSLog(@"Trying to load %@", url);
    
    [parser parseContentsOfURL:url];
    
    if (parser.error) {
        NSLog(@"ERROR: %@", parser.error);
        return [CALayer layer];
    } else {
        return parser.result;
    }
}

-(NSString*)dayNightStringForCurrentVersion:(BOOL)isDay {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        return (isDay ? @"_day" : @"_night");
    } else {
        return (isDay ? @"-day" : @"-night");
    }
}

-(UIImage*)iconForCondition:(int)condition isDay:(BOOL)isDay wantsLargerIcons:(BOOL)larger {
    // larger icons are the "centered-" ones.
    if ([[[UIDevice currentDevice] systemName] floatValue] < 8.0) {
        larger = NO;
    }
    
    NSString *filename = @"";
    
    switch (condition) {
        case 0:
            filename = @"tornado";
            break;
        case 1:
            filename = @"tropical-storm";
            break;
        case 2:
            filename = @"hurricane";
            break;
        case 3:
            filename = [@"severe-thunderstorm" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 4:
        case 45:
            filename = [@"mix-rainfall" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 5:
        case 6:
        case 8:
        case 10:
        case 18:
            filename = [@"sleet" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 7:
            filename = @"flurry";
            break;
        case 9:
            filename = [@"drizzle" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 11:
        case 12:
            filename = [@"rain" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 13:
        case 14:
        case 16:
        case 42:
        case 46:
            filename = @"flurry-snow-snow-shower";
            break;
        case 15:
            filename = @"blowingsnow";
            break;
        case 17:
        case 35:
            filename = [@"hail" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 19:
            filename = @"dust";
            break;
        case 20:
            filename = [@"fog" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 21:
        case 22:
            filename = @"smoke";
            break;
        case 23:
        case 25:
            filename = @"ice";
            break;
        case 24:
            filename = @"breezy";
            break;
        case 26:
        case 27:
        case 28:
            filename = [@"mostly-cloudy" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 29:
            filename = [@"partly-cloudy" stringByAppendingString:[self dayNightStringForCurrentVersion:NO]];
            break;
        case 30:
            filename = [@"partly-cloudy" stringByAppendingString:[self dayNightStringForCurrentVersion:YES]];
            break;
        case 31:
        case 33:
            filename = @"clear-night";
            break;
        case 32:
        case 34:
            filename = @"mostly-sunny";
            break;
        case 36:
            filename = @"hot";
            break;
        case 37:
        case 38:
        case 39:
        case 47:
            filename = [@"scattered-thunderstorm" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 40:
            filename = [@"scattered-showers" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 41:
        case 43:
            filename = [@"blizzard" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        case 44:
            filename = [@"partly-cloudy" stringByAppendingString:[self dayNightStringForCurrentVersion:isDay]];
            break;
        default:
            filename = @"no-report";
            break;
    }
    
    // We now have the filename for that condition.
    
    if (larger) {
        filename = [NSString stringWithFormat:@"centered-%@", filename];
    }
    
    NSString *finalPath = [NSString stringWithFormat:@"/System/Library/PrivateFrameworks/Weather.framework/%@", filename];
    
    // Apply iPad ending if needed.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        finalPath = [finalPath stringByAppendingString:@"~ipad"];
    }
    
    NSString *suffix = @"";
    
    if ([UIScreen mainScreen].scale > 2.0) {
        suffix = @"@3x.png";
    } else if ([UIScreen mainScreen].scale > 1.0) {
        suffix = @"@2x.png";
    } else {
        suffix = @".png";
    }
    
    finalPath = [finalPath stringByAppendingString:suffix];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalPath]) {
        // We'll have to load the image from inside Assets.car instead
        return [UIImage imageNamed:filename inBundle:self.weatherFrameworkBundle compatibleWithTraitCollection:nil];
    }
    
    return [UIImage imageWithContentsOfFile:finalPath];
}

-(NSString*)nameForCondition:(int)condition {
    switch (condition) {
        case 0:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionTornado" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 1:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionTropicalStorm" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 2:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionHurricane" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 3:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionSevereThunderstorm" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 4:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionThunderstorm" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 5:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionMixedRainAndSnow" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 6:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionMixedRainAndSleet" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 7:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionMixedSnowAndSleet" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 8:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionFreezingDrizzle" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 9:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionDrizzle" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 10:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionFreezingRain" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 11:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionShowers1" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 12:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionRain" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 13:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionSnowFlurries" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 14:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionSnowShowers" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 15:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionBlowingSnow" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 16:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionSnow" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 17:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionHail" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 18:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionSleet" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 19:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionDust" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 20:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionFog" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 21:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionHaze" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 22:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionSmoky" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 23:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionFrigid" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 24:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionWindy" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 25:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionCold" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 26:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionCloudy" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 27:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionMostlyCloudyNight" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 28:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionMostlyCloudyDay" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 29:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionPartlyCloudyNight" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 30:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionPartlyCloudyDay" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 31:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionClearNight" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 32:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionSunny" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 33:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionMostlySunnyNight" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 34:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionMostlySunnyDay" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 35:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionMixedRainAndHail" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 36:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionHot" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 37:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionIsolatedThunderstorms" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 38:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionScatteredThunderstorms" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 39:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionScatteredThunderstorms" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 40:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionScatteredShowers" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 41:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionHeavySnow" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 42:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionScatteredSnowShowers" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 43:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionHeavySnow" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 44:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionPartlyCloudy" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 45:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionThundershowers" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 46:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionSnowShowers" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        case 47:
            return [self.weatherFrameworkBundle localizedStringForKey:@"WeatherConditionIsolatedThundershowers" value:@"" table:@"WeatherFrameworkLocalizableStrings"];
        default:
            return @"";
    }
}

-(CALayer*)colourBackingLayerForCondition:(int)condition isDay:(BOOL)isDay {
    CAGradientLayer *layer = [CAGradientLayer new];
    
    UIColor *color1;
    UIColor *color2;
    
    // Yes, this is huge. Oh well. It makes sense. ;P
    
    if (isDay) {
        switch (condition) {
            case 0:
                color1 = [UIColor colorWithRed:0.475000 green:0.486700 blue:0.500000 alpha:1];
                color2 = [UIColor colorWithRed:0.396000 green:0.400000 blue:0.376000 alpha:1];
                break;
            case 1:
                color1 = [UIColor colorWithRed:0.160100 green:0.197300 blue:0.218800 alpha:1];
                color2 = [UIColor colorWithRed:0.448500 green:0.529900 blue:0.577000 alpha:1];
                break;
            case 2:
                color1 = [UIColor colorWithRed:0.495400 green:0.519600 blue:0.551400 alpha:1];
                color2 = [UIColor colorWithRed:0.246000 green:0.274800 blue:0.300000 alpha:1];
                break;
            case 3:
                color1 = [UIColor colorWithRed:0.360700 green:0.440100 blue:0.478700 alpha:1];
                color2 = [UIColor colorWithRed:0.451000 green:0.539400 blue:0.587300 alpha:1];
                break;
            case 4:
                color1 = [UIColor colorWithRed:0.360700 green:0.440100 blue:0.478700 alpha:1];
                color2 = [UIColor colorWithRed:0.451000 green:0.539400 blue:0.587300 alpha:1];
                break;
            case 5:
                color1 = [UIColor colorWithRed:0.583400 green:0.620700 blue:0.663900 alpha:1];
                color2 = [UIColor colorWithRed:0.367700 green:0.400400 blue:0.433100 alpha:1];
                break;
            case 6:
                color1 = [UIColor colorWithRed:0.360700 green:0.440100 blue:0.478700 alpha:1];
                color2 = [UIColor colorWithRed:0.451000 green:0.539400 blue:0.587300 alpha:1];
                break;
            case 7:
                color1 = [UIColor colorWithRed:0.239800 green:0.286600 blue:0.342200 alpha:1];
                color2 = [UIColor colorWithRed:0.490200 green:0.521600 blue:0.545100 alpha:1];
                break;
            case 8:
                color1 = [UIColor colorWithRed:0.664000 green:0.783000 blue:0.830000 alpha:1];
                color2 = [UIColor colorWithRed:0.378000 green:0.477900 blue:0.540000 alpha:1];
                break;
            case 9:
                color1 = [UIColor colorWithRed:0.664000 green:0.783000 blue:0.830000 alpha:1];
                color2 = [UIColor colorWithRed:0.378000 green:0.477900 blue:0.540000 alpha:1];
                break;
            case 10:
                color1 = [UIColor colorWithRed:0.303800 green:0.421700 blue:0.490000 alpha:1];
                color2 = [UIColor colorWithRed:0.294000 green:0.361200 blue:0.420000 alpha:1];
                break;
            case 11:
                color1 = [UIColor colorWithRed:0.476000 green:0.605200 blue:0.680000 alpha:1];
                color2 = [UIColor colorWithRed:0.325000 green:0.427100 blue:0.500000 alpha:1];
                break;
            case 12:
                color1 = [UIColor colorWithRed:0.303800 green:0.421700 blue:0.490000 alpha:1];
                color2 = [UIColor colorWithRed:0.294000 green:0.361200 blue:0.420000 alpha:1];
                break;
            case 13:
                color1 = [UIColor colorWithRed:0.364900 green:0.482500 blue:0.585400 alpha:1];
                color2 = [UIColor colorWithRed:0.461200 green:0.563700 blue:0.639900 alpha:1];
                break;
            case 14:
                color1 = [UIColor colorWithRed:0.610200 green:0.768300 blue:0.875300 alpha:1];
                color2 = [UIColor colorWithRed:0.434400 green:0.513800 blue:0.576300 alpha:1];
                break;
            case 15:
                color1 = [UIColor colorWithRed:0.525000 green:0.630000 blue:0.700000 alpha:1];
                color2 = [UIColor colorWithRed:0.350000 green:0.425000 blue:0.500000 alpha:1];
                break;
            case 16:
                color1 = [UIColor colorWithRed:0.610200 green:0.768300 blue:0.875300 alpha:1];
                color2 = [UIColor colorWithRed:0.434400 green:0.513800 blue:0.576300 alpha:1];
                break;
            case 17:
                color1 = [UIColor colorWithRed:0.637400 green:0.663600 blue:0.688900 alpha:1];
                color2 = [UIColor colorWithRed:0.495900 green:0.579100 blue:0.667900 alpha:1];
                break;
            case 18:
                color1 = [UIColor colorWithRed:0.514900 green:0.593700 blue:0.646700 alpha:1];
                color2 = [UIColor colorWithRed:0.323600 green:0.397400 blue:0.437400 alpha:1];
                break;
            case 19:
                color1 = [UIColor colorWithRed:0.806300 green:0.795800 blue:0.752000 alpha:1];
                color2 = [UIColor colorWithRed:0.469400 green:0.467000 blue:0.441600 alpha:1];
                break;
            case 20:
                color1 = [UIColor colorWithRed:0.480000 green:0.556000 blue:0.600000 alpha:1];
                color2 = [UIColor colorWithRed:0.448500 green:0.529900 blue:0.577000 alpha:1];
                break;
            case 21:
                color1 = [UIColor colorWithRed:0.760000 green:0.742300 blue:0.684000 alpha:1];
                color2 = [UIColor colorWithRed:0.513900 green:0.560400 blue:0.554000 alpha:1];
                break;
            case 22:
                color1 = [UIColor colorWithRed:0.552600 green:0.583000 blue:0.628000 alpha:1];
                color2 = [UIColor colorWithRed:0.573400 green:0.571400 blue:0.559500 alpha:1];
                break;
            case 23:
                color1 = [UIColor colorWithRed:0.440000 green:0.726000 blue:0.880000 alpha:1];
                color2 = [UIColor colorWithRed:0.386900 green:0.587000 blue:0.730000 alpha:1];
                break;
            case 24:
                color1 = [UIColor colorWithRed:0.545600 green:0.726400 blue:0.847600 alpha:1];
                color2 = [UIColor colorWithRed:0.421500 green:0.511200 blue:0.600800 alpha:1];
                break;
            case 25:
                color1 = [UIColor colorWithRed:0.572000 green:0.736300 blue:0.880000 alpha:1];
                color2 = [UIColor colorWithRed:0.434000 green:0.567000 blue:0.700000 alpha:1];
                break;
            case 26:
                color1 = [UIColor colorWithRed:0.557600 green:0.627000 blue:0.680000 alpha:1];
                color2 = [UIColor colorWithRed:0.365000 green:0.437000 blue:0.500000 alpha:1];
                break;
            case 27:
                color1 = [UIColor colorWithRed:0.440000 green:0.726000 blue:0.880000 alpha:1];
                color2 = [UIColor colorWithRed:0.386900 green:0.587000 blue:0.730000 alpha:1];
                break;
            case 28:
                color1 = [UIColor colorWithRed:0.440000 green:0.726000 blue:0.880000 alpha:1];
                color2 = [UIColor colorWithRed:0.386900 green:0.587000 blue:0.730000 alpha:1];
                break;
            case 29:
                color1 = [UIColor colorWithRed:0.180000 green:0.531500 blue:0.750000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 30:
                color1 = [UIColor colorWithRed:0.180000 green:0.531500 blue:0.750000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 31:
                color1 = [UIColor colorWithRed:0.109500 green:0.543800 blue:0.730000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 32:
                color1 = [UIColor colorWithRed:0.109500 green:0.543800 blue:0.730000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 33:
                color1 = [UIColor colorWithRed:0.109500 green:0.543800 blue:0.730000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 34:
                color1 = [UIColor colorWithRed:0.109500 green:0.543800 blue:0.730000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 35:
                color1 = [UIColor colorWithRed:0.611200 green:0.702300 blue:0.806300 alpha:1];
                color2 = [UIColor colorWithRed:0.415800 green:0.463400 blue:0.540000 alpha:1];
                break;
            case 36:
                color1 = [UIColor colorWithRed:0.540000 green:0.858000 blue:0.900000 alpha:1];
                color2 = [UIColor colorWithRed:0.086790 green:0.528200 blue:0.802500 alpha:1];
                break;
            case 37:
                color1 = [UIColor colorWithRed:0.239800 green:0.286600 blue:0.342200 alpha:1];
                color2 = [UIColor colorWithRed:0.490200 green:0.521600 blue:0.545100 alpha:1];
                break;
            case 38:
                color1 = [UIColor colorWithRed:0.515900 green:0.618600 blue:0.670000 alpha:1];
                color2 = [UIColor colorWithRed:0.324000 green:0.372100 blue:0.400000 alpha:1];
                break;
            case 39:
                color1 = [UIColor colorWithRed:0.315500 green:0.693200 blue:0.896700 alpha:1];
                color2 = [UIColor colorWithRed:0.370600 green:0.555500 blue:0.687700 alpha:1];
                break;
            case 40:
                color1 = [UIColor colorWithRed:0.247800 green:0.365500 blue:0.420000 alpha:1];
                color2 = [UIColor colorWithRed:0.279400 green:0.326900 blue:0.349900 alpha:1];
                break;
            case 41:
                color1 = [UIColor colorWithRed:0.477500 green:0.618200 blue:0.768600 alpha:1];
                color2 = [UIColor colorWithRed:0.412900 green:0.555400 blue:0.680000 alpha:1];
                break;
            case 42:
                color1 = [UIColor colorWithRed:0.260700 green:0.315700 blue:0.389000 alpha:1];
                color2 = [UIColor colorWithRed:0.409800 green:0.486300 blue:0.573800 alpha:1];
                break;
            case 43:
                color1 = [UIColor colorWithRed:0.260700 green:0.315700 blue:0.389000 alpha:1];
                color2 = [UIColor colorWithRed:0.409800 green:0.486300 blue:0.573800 alpha:1];
                break;
            case 44:
                color1 = [UIColor colorWithRed:0.259900 green:0.558700 blue:0.747600 alpha:1];
                color2 = [UIColor colorWithRed:0.522900 green:0.712300 blue:0.830000 alpha:1];
                break;
            case 45:
                color1 = [UIColor colorWithRed:0.315500 green:0.693200 blue:0.896700 alpha:1];
                color2 = [UIColor colorWithRed:0.370600 green:0.555500 blue:0.687700 alpha:1];
                break;
            case 46:
                color1 = [UIColor colorWithRed:0.477500 green:0.618200 blue:0.768600 alpha:1];
                color2 = [UIColor colorWithRed:0.412900 green:0.555400 blue:0.680000 alpha:1];
                break;
            default:
                break;
        }
    } else {
        switch (condition) {
            case 0:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 1:
                color1 = [UIColor colorWithRed:0.495400 green:0.519600 blue:0.551400 alpha:1];
                color2 = [UIColor colorWithRed:0.246000 green:0.274800 blue:0.300000 alpha:1];
                break;
            case 2:
                color1 = [UIColor colorWithRed:0.270000 green:0.283500 blue:0.300000 alpha:1];
                color2 = [UIColor colorWithRed:0.036000 green:0.037800 blue:0.040000 alpha:1];
                break;
            case 3:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 4:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 5:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 6:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 7:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 8:
                color1 = [UIColor colorWithRed:0.079900 green:0.094430 blue:0.100200 alpha:1];
                color2 = [UIColor colorWithRed:0.067900 green:0.085840 blue:0.096990 alpha:1];
                break;
            case 9:
                color1 = [UIColor colorWithRed:0.079900 green:0.094430 blue:0.100200 alpha:1];
                color2 = [UIColor colorWithRed:0.067900 green:0.085840 blue:0.096990 alpha:1];
                break;
            case 10:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 11:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 12:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 13:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 14:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 15:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 16:
                color1 = [UIColor colorWithRed:0.087390 green:0.143200 blue:0.173400 alpha:1];
                color2 = [UIColor colorWithRed:0.252400 green:0.274000 blue:0.334700 alpha:1];
                break;
            case 17:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 18:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 19:
                color1 = [UIColor colorWithRed:0.054280 green:0.053080 blue:0.051000 alpha:1];
                color2 = [UIColor colorWithRed:0.193700 green:0.187400 blue:0.154700 alpha:1];
                break;
            case 20:
                color1 = [UIColor colorWithRed:0.140000 green:0.155800 blue:0.200000 alpha:1];
                color2 = [UIColor colorWithRed:0.061720 green:0.112400 blue:0.140800 alpha:1];
                break;
            case 21:
                color1 = [UIColor colorWithRed:0.141200 green:0.145100 blue:0.152900 alpha:1];
                color2 = [UIColor colorWithRed:0.172500 green:0.176500 blue:0.141200 alpha:1];
                break;
            case 22:
                color1 = [UIColor colorWithRed:0.253800 green:0.267900 blue:0.288600 alpha:1];
                color2 = [UIColor colorWithRed:0.182100 green:0.181500 blue:0.177700 alpha:1];
                break;
            case 23:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 24:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 25:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 26:
                color1 = [UIColor colorWithRed:0.211500 green:0.227300 blue:0.235800 alpha:1];
                color2 = [UIColor colorWithRed:0.100300 green:0.109800 blue:0.119100 alpha:1];
                break;
            case 27:
                color1 = [UIColor colorWithRed:0.087390 green:0.143200 blue:0.173400 alpha:1];
                color2 = [UIColor colorWithRed:0.252400 green:0.274000 blue:0.334700 alpha:1];
                break;
            case 28:
                color1 = [UIColor colorWithRed:0.087390 green:0.143200 blue:0.173400 alpha:1];
                color2 = [UIColor colorWithRed:0.252400 green:0.274000 blue:0.334700 alpha:1];
                break;
            case 29:
                color1 = [UIColor colorWithRed:0.013000 green:0.050050 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.188500 green:0.210200 blue:0.269300 alpha:1];
                break;
            case 30:
                color1 = [UIColor colorWithRed:0.013000 green:0.050050 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.188500 green:0.210200 blue:0.269300 alpha:1];
                break;
            case 31:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 32:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 33:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 34:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 35:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 36:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 37:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 38:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 39:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 40:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 41:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 42:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 43:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 44:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 45:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 46:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            default:
                break;
        }
    }
    
    if (!color1 || !color2) {
        // ABORT!
        layer.colors = @[(id)[UIColor blackColor].CGColor];
    } else {
        layer.colors = @[(id)color2.CGColor, (id)color1.CGColor];
    }
    
    return layer;
}

- (NSURL*)filenameForCondition:(int)arg1 isDay:(_Bool)arg2 largest:(BOOL)takeLargest {
    // Return NSURL
    
    NSString *predicateString = [NSString stringWithFormat:@"%02d_%@", arg1, (arg2 ? @"day" : @"night")];
    
    NSArray *filenames = [self.weatherFrameworkBundle pathsForResourcesOfType:@".caml" inDirectory:@""];
    
    NSString *resultPath;
    
    for (NSString *path in filenames) {
        if (takeLargest) {
            if ([path rangeOfString:predicateString].location == NSNotFound) {
                break;
            }
            
            resultPath = path;
        } else {
            if ([path rangeOfString:predicateString].location != NSNotFound) {
                resultPath = path;
                break;
            }
        }
    }
    
    if (!resultPath) {
        predicateString = [NSString stringWithFormat:@"%02d", arg1];
        
        for (NSString *path in filenames) {
            if ([path rangeOfString:predicateString].location != NSNotFound) {
                resultPath = path;
                break;
            }
        }
    }
    
    if (!resultPath) {
        return [NSURL fileURLWithPath:@""];
    } else {
        return [NSURL fileURLWithPath:resultPath];
    }
}

#pragma mark CAMLParser delegate

- (struct CGImage *)CAMLParser:(id)arg1 resourceForURL:(id)arg2 {
    // I have no idea if this is NSURL or NSString
    NSString *urlString = @"";
    
    if ([[arg2 class] isEqual:[NSURL class]]) {
        urlString = [(NSURL*)arg2 path];
    } else if ([[arg2 class] isEqual:[NSString class]]) {
        urlString = (NSString*)arg2;
    }
    
    // Strip out to the raw filename.
    urlString = [urlString stringByReplacingOccurrencesOfString:@"assets/" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@".png" withString:@".cpbitmap"];
    
    UIImage *image;
    if (![[NSFileManager defaultManager] fileExistsAtPath:urlString]) {
        urlString = [urlString stringByReplacingOccurrencesOfString:@".cpbitmap" withString:@".png"];
        image = [UIImage imageWithContentsOfFile:urlString];
    } else {
        image = [UIImage imageWithContentsOfCPBitmapFile:urlString flags:0];
    }
    
    return image.CGImage;
}

- (void)CAMLParser:(id)arg1 didLoadResource:(struct CGImage *)arg2 fromURL:(id)arg3 {
    // Cool story bro.
}

- (Class)CAMLParser:(id)arg1 didFailToFindClassWithName:(NSString*)arg2 {
    if ([arg2 isEqualToString:@"LKState"]) {
        return [objc_getClass("CAState") class];
    } else if ([arg2 isEqualToString:@"LKStateAddAnimation"]) {
        return [objc_getClass("CAStateAddAnimation") class];
    } else if ([arg2 isEqualToString:@"LKStateAddElement"]) {
        return [objc_getClass("CAStateAddElement") class];
    } else if ([arg2 isEqualToString:@"LKStateElement"]) {
        return [objc_getClass("CAStateElement") class];
    } else if ([arg2 isEqualToString:@"LKStateRemoveAnimation"]) {
        return [objc_getClass("CAStateRemoveAnimation") class];
    } else if ([arg2 isEqualToString:@"LKStateRemoveElement"]) {
        return [objc_getClass("CAStateRemoveElement") class];
    } else if ([arg2 isEqualToString:@"LKStateSetValue"]) {
        return [objc_getClass("CAStateSetValue") class];
    } else if ([arg2 isEqualToString:@"LKStateTransition"]) {
        return [objc_getClass("CAStateTransition") class];
    } else if ([arg2 isEqualToString:@"LKStateTransitionElement"]) {
        return [objc_getClass("CAStateTransitionElement") class];
    } else {
        return nil;
    }
}

@end
