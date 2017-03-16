@interface YTTabTitlesView
@end
@interface YTTabsRendererView : UIView
-(YTTabTitlesView *)tabTitlesView;
@end


%hook YTUserDefaults
-(BOOL)forceEnableFusionNavigation {
	return NO;
}
-(void)setForceEnableFusionNavigation:(BOOL)arg1 {
	%orig(NO);
}
%end
%hook YTGlobalConfig
-(BOOL)isFusionNavigationEnabled {
	return NO;
}
%end
%hook YTSettings
-(BOOL)forceEnableFusionNavigation {
	return NO;
}
-(void)setForceEnableFusionNavigation:(BOOL)arg1 {
	%orig(NO);
}
%end
%hook YTIFusionConfig
-(BOOL)hasEnableFusionNav {
	return NO;
}
-(BOOL)enableFusionNav {
	return NO;
}
%end
%hook YTTabTitlesView
-(id)initWithLocator:(id)arg1 styleContext:(id)arg2 {
NSString *style = arg2;
	if ([style isEqualToString:@"kYTStyleContextDefault"]) {
		return nil;
	}
	else {
		return %orig;
	}
}
%end