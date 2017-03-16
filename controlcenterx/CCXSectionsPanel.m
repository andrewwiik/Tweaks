#import "CCXSectionsPanel.h"

// static NSInteger DictionaryTextComparator(id a. id b. void *context)
// {
// 	return [[(NSDictionary *)context objectForKey:a] localizedCaseInsensitiveCompare:[(NSDictionary *)context objectForKey:b]];
// }

@implementation CCXSectionsPanel
+ (instancetype)sharedInstance {
	static CCXSectionsPanel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NSClassFromString(@"CCXSectionsPanel") alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (NSArray *)sortedSectionIdentifiers {
	if (!self.sections || !self.sectionIdentifiers) {
		[self loadSections];
	}
	return [self.sectionIdentifiers copy];
}

- (void)loadSections {
	NSMutableArray *sections = [NSMutableArray new];
	[sections addObject:[[CCXSectionObject alloc] initWithSectionClass:NSClassFromString(@"CCXMiniMediaPlayerSectionController")]];
	[sections addObject:[[CCXSectionObject alloc] initWithSectionClass:NSClassFromString(@"CCUIQuickLaunchSectionController")]];
	[sections addObject:[[CCXSectionObject alloc] initWithSectionClass:NSClassFromString(@"CCUISettingsSectionController")]];
	[sections addObject:[[CCXSectionObject alloc] initWithSectionClass:NSClassFromString(@"CCXAirAndNightSectionController")]];
	[sections addObject:[[CCXSectionObject alloc] initWithSectionClass:NSClassFromString(@"CCXVolumeAndBrightnessSectionController")]];
	self.sections = [sections copy];
	
	if (!self.sectionIdentifiers) {
		self.sectionIdentifiers = [NSMutableArray new];
	}
	
	for (CCXSectionObject *section in self.sections) {
		if (section.sectionIdentifier) {
			[self.sectionIdentifiers addObject:section.sectionIdentifier];
		}
	}
}

- (CCXSectionObject *)sectionObjectForIdentifier:(NSString *)identifier {
	for (CCXSectionObject *section in self.sections) {
		if ([section.sectionIdentifier isEqualToString:identifier]) {
			return section;
		}
	}
	return nil;
}

- (UIColor *)primaryColorForSectionIdentifier:(NSString *)identifier {
	return nil;
}

@end