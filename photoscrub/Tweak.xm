@interface PLPhotoScrubber : NSObject
-(void)reloadData;
@end

%hook UIDevice
- (void)_setActiveUserInterfaceIdiom:(long long)arg1 {
	%orig(1);
}
- (long long)userInterfaceIdiom {
	return 1;
}
%end
%hook PUPhotoBrowserControllerPadSpec
- (BOOL)shouldShowPhotoScrubber {
	return TRUE;
}
%end
%hook PUPhotoBrowserControllerSpec
- (BOOL)shouldShowPhotoScrubber {
	return TRUE;
}
%end