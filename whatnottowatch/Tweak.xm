#import <UIKit/UIKit.h>
@interface YTResponder : NSObject
@end

@interface YTGuideCellController
-(void)didSelectItem;
@end
@interface YTBaseGuideEntryCell : UICollectionViewCell
-(YTGuideCellController *)parentResponder;
@end
@interface YTGuideEntryCell : YTBaseGuideEntryCell
-(id)title;
@end
@interface PBRootObject : NSObject
@end
@interface PBGeneratedMessage : PBRootObject
@end
@interface YTNavigation_iPhone : NSObject
-(void)openNavigationMenuAndSelectEntryWithNavigationEndpoint:(id)arg1;
-(id)buttPoint;
@end
@interface YTIBrowseEndpoint : PBGeneratedMessage
@property (nonatomic,retain) NSString * browseId;
@end
@interface YTINavigationEndpoint : PBGeneratedMessage
@end
@interface YTIGuideEntryRenderer : PBGeneratedMessage
@property (nonatomic,retain) NSString * title; 
@property (nonatomic,retain) YTINavigationEndpoint * navigationEndpoint;
@end

@interface YTAppDelegate : UIResponder
-(YTNavigation_iPhone *)navigation;
@end
YTGuideEntryCell* SubscriptionsCell;
YTINavigationEndpoint* SubscriptionsEndpoint;
%hook YTGuideEntryCell
- (void)layoutSubviews {
	%orig;
	if ([[self title] isEqualToString:@"Subscriptions"]) {
		SubscriptionsCell = self;
	} 
}
%end
%hook YTAppDelegate
- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
	%orig;
	[[self navigation] openNavigationMenuAndSelectEntryWithNavigationEndpoint:SubscriptionsEndpoint];
	[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
	return %orig;
}
%new
- (void)timerFired:(NSTimer *)timer {
      [[SubscriptionsCell parentResponder] didSelectItem];
}
%end
%hook YTIGuideEntryRenderer
-(id)navigationEndpoint {
	if ([self.title isEqualToString:@"Subscriptions"]) {
		SubscriptionsEndpoint = %orig;
		return %orig;
	}
	else return %orig;
}
%end
%hook YTNavigation_iPhone
%new
-(id)buttPoint {
	return SubscriptionsEndpoint;
}
%end

