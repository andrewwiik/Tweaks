%config(generator=internal)

NSMutableArray *blockURLS = nil;

%hook UIDevice
- (id)spt_hardwareIdentifier {
	if (!blockURLS) {
		NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/andrewwiik/bdayspotify/master/block.json"]];
		if (data) {
			NSError *error=nil;
			NSMutableDictionary *response=[NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error]; 
			if (response) {
				if ([response objectForKey:@"keywords"]) {
					blockURLS = [[response objectForKey:@"keywords"] mutableCopy];
				}
			}
			NSLog(@"%@",blockURLS);
		}
	}
	return @"iPad5,3";
}
%end

%hook SPTCoreCreateOptions
- (void)setIsTablet:(char)isTablet {
	%orig(true);
}
- (void)setEnableMftRulesForPlayer:(char)enable {
	%orig(false);
}
%end

%hook SPTAdFeatureFlagChecks
- (char)isAdsEnabled {
	return false;
}
%end

%hook SPTUpsellImplementation

- (bool)isUpsellFeatureEnabled {
	return NO;
}

%end

%hook CSCore

- (BOOL)isLimitAdTrackingEnabled {
	return YES;
}

%end

%hook SPTProductState
- (id)objectForKeyedSubscript:(NSString *)key {
	if ([key isEqualToString:@"ads"]) return [NSNumber numberWithChar:0];
	else if ([key isEqualToString:@"streaming-rules"]) return [NSString stringWithFormat:@"tablet-free"];
	else if ([key isEqualToString:@"type"]) return [NSString stringWithFormat:@"premium"];
	else if ([key isEqualToString:@"shuffle"]) return [NSNumber numberWithChar:0];
	else if ([key isEqualToString:@"on-demand"]) return [NSNumber numberWithChar:1];
	else if ([key isEqualToString:@"high-bitrate"]) return [NSNumber numberWithChar:1];
	else if ([key isEqualToString:@"low-bitrate"]) return [NSNumber numberWithChar:0];
	else if ([key isEqualToString:@"financial-product"]) return [NSString stringWithFormat:@"pr:premium,tc:0"];
	else return %orig;
}
- (id)stringForKey:(NSString *)key {
	if ([key isEqualToString:@"ads"]) return [NSString stringWithFormat:@"0"];
	else if ([key isEqualToString:@"streaming-rules"]) return [NSString stringWithFormat:@"tablet-free"];
	else if ([key isEqualToString:@"type"]) return [NSString stringWithFormat:@"premium"];
	else if ([key isEqualToString:@"shuffle"]) return [NSString stringWithFormat:@"0"];
	else if ([key isEqualToString:@"on-demand"]) return [NSString stringWithFormat:@"1"];
	else if ([key isEqualToString:@"high-bitrate"]) return [NSString stringWithFormat:@"1"];
	else if ([key isEqualToString:@"low-bitrate"]) return [NSString stringWithFormat:@"0"];
	else if ([key isEqualToString:@"financial-product"]) return [NSString stringWithFormat:@"pr:premium,tc:0"];
	else return %orig;
}
%end
%hook AdsFeatureImplementation
- (void)createSlots {
	return;
}
%end

%hook SPTAdsManager

- (bool)adBreakInProgress {
	return YES;
}

- (void)disablePrerollAdExperience:(BOOL)arg1 featureIdentifier:(id)arg2 {
	arg1=YES;
}

- (void)disableMidrollAdExperience:(BOOL)arg1 playOriginContext:(id)arg2 {
	arg1=YES;
}

- (id)adFeatureChecker {
	return nil;
}

- (bool)isPrerollForced {
	return NO;
}

- (void)displayAd {
	return;
}

- (bool)isThirdPartyAdInProgress {
	return YES;
}

%end

%hook SPTArtistOverviewModel

- (id)singles {
	return %orig;
}

%end

%hook NSURLRequest
+ (id)requestWithURL:(NSURL *)url {
	if (blockURLS) {
		for (NSString *keyword in blockURLS) {
			if ([url.absoluteString rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound) {
				url = [NSURL URLWithString:@""];
				break;
			}
		}
	}
	return %orig;
}
+ (id)requestWithURL:(NSURL *)url cachePolicy:(unsigned long long)arg2 timeoutInterval:(double)arg3 {
	if (blockURLS) {
		for (NSString *keyword in blockURLS) {
			if ([url.absoluteString rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound) {
				url = [NSURL URLWithString:@""];
				break;
			}
		}
	}
	return %orig;
}
- (id)initWithURL:(NSURL *)url {
	if (blockURLS) {
		for (NSString *keyword in blockURLS) {
			if ([url.absoluteString rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound) {
				url = [NSURL URLWithString:@""];
				break;
			}
		}
	}
	return %orig;
}
- (id)initWithURL:(NSURL *)url cachePolicy:(unsigned long long)arg2 timeoutInterval:(double)arg3 {
	if (blockURLS) {
		for (NSString *keyword in blockURLS) {
			if ([url.absoluteString rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound) {
				url = [NSURL URLWithString:@""];
				break;
			}
		}
	}
	return %orig;
}
+ (id)frRequestWithURL:(NSURL *)url {
	if (blockURLS) {
		for (NSString *keyword in blockURLS) {
			if ([url.absoluteString rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound) {
				url = [NSURL URLWithString:@""];
				break;
			}
		}
	}
	return %orig;
}
+ (id)frRequestWithURL:(NSURL *)url cachePolicy:(unsigned long long)arg2 timeoutInterval:(double)arg3 {
	if (blockURLS) {
		for (NSString *keyword in blockURLS) {
			if ([url.absoluteString rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound) {
				url = [NSURL URLWithString:@""];
				break;
			}
		}
	}
	return %orig;
}
%end

%hook SPTUpsellGeneralManager
- (void)triggerUpsellForReason:(int)reason completion:(id)completion {
	return;
}
%end
