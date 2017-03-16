#import "headers.h"
#import "Weather/ALEWeatherViewController.h"
#import "Stocks/ALEStocksViewController.h"
#import "Notes/ALENotesComposeViewController.h"
#import <Stocks/StockManager.h>

@interface ChartUpdater (ALEPrivate)
- (void)setDelegate:(id)arg1;
- (void)parseData:(id)arg1;
@end

@interface ICNotesExtensionClient : NSObject
+ (instancetype)sharedExtensionClient;
+ (void)initialize;
- (void)createNoteWithContents:(NSString *)contents completionHandler:(id)handler;
@end

%hook ChartUpdater
-(void)parseData:(id)arg1 {
%orig;
NSLog(@"%@",arg1);
}
-(void)failWithError:(id)arg1 {
%orig;
NSLog(@"%@", arg1);
}
%end

%hook SBApplicationShortcutMenu

- (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem *)shortcutItem index:(long long)arg3 {
		if ([shortcutItem.type isEqualToString:@"com.apple.notes.newNote"]) {
			SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self,"_contentView");
			[contentView showNewNote];
    	}
  		else {
  			%orig;
  		}
}
%end

%hook SBApplicationShortcutMenuContentView
%property (nonatomic, retain) ALENotesComposeViewController *ccController;
%new
- (void)ALEClearMenu {
    UIView *rowContainer = MSHookIvar<UIView*>(self,"_rowContainer");
    UIView *dividerContainer = MSHookIvar<UIView*>(self,"_dividerContainer");
    rowContainer.hidden = YES;
    dividerContainer.hidden = YES;
}
%new
- (void)showNewNote {

	[self ALEClearMenu];
	[self highlightGesture].enabled = NO;

	ALENotesComposeViewController *composeController = [[ALENotesComposeViewController alloc] init];
	composeController.view.translatesAutoresizingMaskIntoConstraints = NO;
	self.ccController = composeController;
	[self addSubview:composeController.view];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:composeController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:composeController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:composeController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:composeController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}
%new
- (void)showWeather {

	[self ALEClearMenu];
	[self highlightGesture].enabled = NO;
	City *localCity = [[NSClassFromString(@"WeatherPreferences") sharedPreferences] localWeatherCity];
	ALEWeatherViewController *weatherController = [[ALEWeatherViewController alloc] initWithCity:localCity viewType:ALEWeatherViewTypeDaily celsius:NO];
	weatherController.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:weatherController.view];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

}

%new
- (void)showStocks {

	if ([self loadBundleNeededALE]) {
	[self ALEClearMenu];
	[self highlightGesture].enabled = NO;
	Stock *stock = (Stock *)[[[NSClassFromString(@"StockManager") sharedManager] stocksList] objectAtIndex:4];
	ALEStocksViewController *stocksViewController = [[ALEStocksViewController alloc] initWithStock:stock interval:2];
	stocksViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:stocksViewController.view];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:stocksViewController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:stocksViewController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:stocksViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:stocksViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}
}
%new
-(void)chartUpdater:(ChartUpdater *)arg1 didReceiveStockChartData:(id)arg2 {
      [arg1 parseData:arg2];
      NSLog(@"Chart Data: %@", arg2);
}
%new
-(void)chartUpdater:(ChartUpdater *)arg1 didFailWithError:(id)arg2 {
   NSLog(@"Chart Error: %@", arg2);
}

%new
- (BOOL)loadBundleNeededALE {
NSString *fullPath = [NSString stringWithFormat:@"/System/Library/Assistant/UIPlugins/Stocks.siriUIBundle"];
NSBundle *bundle;
bundle = [NSBundle bundleWithPath:fullPath];
return [bundle load];
}

- (void)_populateRowsWithShortcutItems:(id)arg1 application:(SBApplication *)arg2 {
   if ([[arg2 bundleIdentifier] isEqualToString: @"com.apple.weather"]) {
   	%orig;
      [self showWeather];
   }
   if ([[arg2 bundleIdentifier] isEqualToString: @"com.apple.stocks"]) {
   	%orig;
      [self showStocks];
   }
   if ([[arg2 bundleIdentifier] isEqualToString: @"com.apple.stocks"]) {
   	%orig;
      [self createNote];
   }
   else %orig;
}

%new
- (void)createNote {
	[[%c(ICNotesExtensionClient) sharedExtensionClient] performSelector:@selector(createNoteWithContents:completionHandler:) withObject:@"poop" withObject:nil];
}

%new
- (UILongPressGestureRecognizer *)highlightGesture {
	return MSHookIvar<id>(self,"_pressGestureRecognizer");//disables longpresgesture so our gesturs can be used
}
%end

%hook SBApplicationShortcutStoreManager
- (id)shortcutItemsForBundleIdentifier:(id)identifier {
   if ([identifier isEqualToString:@"com.apple.weather"]) {
      UIApplicationShortcutItem *respring = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple" localizedTitle:@" "];
      UIApplicationShortcutItem *reboot = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple" localizedTitle:@" "];
      UIApplicationShortcutItem *power = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple" localizedTitle:@" "];
      return [NSMutableArray arrayWithObjects:respring, reboot, power, nil];
   }
   else if ([identifier isEqualToString:@"com.apple.stocks"]) {
      UIApplicationShortcutItem *respring = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple" localizedTitle:@" "];
      UIApplicationShortcutItem *reboot = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple" localizedTitle:@" "];
      UIApplicationShortcutItem *power = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple" localizedTitle:@" "];
      return [NSMutableArray arrayWithObjects:respring, reboot, power, nil];
   }
   else return %orig;
}
%end

%hook UIView
%property (assign, nonatomic) id delegate;
%new
- (void)suckPenisBitch {

}
%end