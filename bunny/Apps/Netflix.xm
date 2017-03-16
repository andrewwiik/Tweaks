@interface LolomoContinueWatchingEntity : NSObject
@property (nonatomic, retain) NSString *currentEntityType;
@property (nonatomic, retain) NSString *currentSummaryTitle;
@property (nonatomic, retain) NSString *currentTitle;
@property (nonatomic, retain) NSString *detailsShowTitle;
@property (nonatomic, retain) NSNumber *currentEpisodeNumber;
- (NSDictionary *)dictionaryRepresentation;
- (NSNumber *)currentEntityId;
@end

NSMutableSet *continueWatchingEntities = [NSMutableSet new];

%hook LolomoContinueWatchingEntity
- (void)setValuesForKeysWithDictionary:(id)dictionary {
	%orig;
	int count = [continueWatchingEntities count];
	[continueWatchingEntities addObject:self];
	if (count != [continueWatchingEntities count]) {
		NSMutableArray *shortcuts = [NSMutableArray new];
		for (LolomoContinueWatchingEntity *entity in continueWatchingEntities) {

			NSString *title = nil;
			NSString *subtitle = @"Continue Watching";
			NSMutableDictionary *userInfo = [NSMutableDictionary new];
			[userInfo setObject:[[entity currentEntityId] stringValue] forKey:@"entityID"];
			if ([entity.currentEntityType isEqualToString:[NSString stringWithFormat:@"episode"]]) {
				title = [NSString stringWithFormat:@"%@ - Ep %@", entity.detailsShowTitle, [entity.currentEpisodeNumber stringValue]];
			}
			else if ([entity.currentEntityType isEqualToString:[NSString stringWithFormat:@"movie"]]) {
				title = [NSString stringWithFormat:@"%@", entity.currentTitle];
			}

			UIMutableApplicationShortcutItem *shortcut = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.netflix.Netflix.continue" 
																										 localizedTitle:title
																									  localizedSubtitle:subtitle 
																									               icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay]
																									           userInfo:userInfo];
			[shortcuts addObject:shortcut];
			[[UIApplication sharedApplication] setShortcutItems:shortcuts];
		}
	}
}
- (NSUInteger)hash {
  return [[self currentEntityId] integerValue];
}
- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }

  if (![object isKindOfClass:[self class]]) {
    return NO;
  }
  if ([(LolomoContinueWatchingEntity *)object currentEntityId] == [self currentEntityId]) {
  	return YES;
  }
  return NO;
}
%end

%hook AppDelegate
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
  if ([shortcutItem.type isEqualToString:@"com.netflix.Netflix.continue"]) {
    NSDictionary *userInfo = shortcutItem.userInfo;
    NSString *entityID = [userInfo valueForKey:@"entityID"];
    [self application:[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"nflx://www.netflix.com/watch/%@", entityID]] options:[NSDictionary new]];
    completionHandler(YES);
  } else %orig;
}
%end


%ctor {
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.netflix.Netflix"]) { // Photos App
          %init;
  }
}