#import <UIKit/UIKit.h> // We need to Import UJIKIt
#import <CoreGraphics/CoreGraphics.h> // We need to Also Import the CoreGraphics Framework
#import <QuartzCore/QuartzCore.h> // and the QuartzCore Framework

@interface MusicApplicationDelegate : UIResponder
-(void)_switchToTabWithIdentifier:(id)arg1 completion:(id)arg2 ;
@end

%hook MusicApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSString *playlistView = @"playlists";
	[self _switchToTabWithIdentifier:playlistView completion: nil];
	return %orig;

	}
%end
