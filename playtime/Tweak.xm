#import "headers.h"

%hook MusicStorePlaylistEntityValueProvider
%new
- (int)totalPlayTimeInSeconds2 {
	int totalSecs = 0;
	for (MusicStoreItemMetadataContext *song in [[self storeItemMetadataContext] childrenStoreItemMetadataContexts]) {
		int duration = [[[song JSDictionary] objectForKey:@"trackDuration"] intValue];
		totalSecs = totalSecs + duration;
	}
	return totalSecs;
}
%new
- (NSString *)playDuration2 {
	NSUInteger elapsedSeconds = (NSUInteger)[self totalPlayTimeInSeconds2];
	NSUInteger h = elapsedSeconds / 3600;
	NSUInteger m = (elapsedSeconds / 60) % 60;
	NSUInteger s = elapsedSeconds % 60;
	if (h < 1) {
		return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)m, (unsigned long)s];
	}
	else return  [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s];
}
%end

%hook MusicStoreEntityProvider
%new
- (int)totalPlayTimeInSeconds {
	int totalSecs = 0;
	for (MusicStoreItemMetadataContext *song in [self storeItemMetadataContexts]) {
		int duration = [[[song JSDictionary] objectForKey:@"trackDuration"] intValue];
		totalSecs = totalSecs + duration;
	}
	return totalSecs;
}
%new
- (NSString *)playDuration {
	NSUInteger elapsedSeconds = (NSUInteger)[self totalPlayTimeInSeconds];
	NSUInteger h = elapsedSeconds / 3600;
	NSUInteger m = (elapsedSeconds / 60) % 60;
	NSUInteger s = elapsedSeconds % 60;
	if (h < 1) {
		return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)m, (unsigned long)s];
	}
	else return  [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s];
}
%end

%hook MusicMediaEntityProvider
%new
- (int)totalPlayTimeInSeconds {
	int totalSecs = 0;
	for (MPMediaItem *song in [[self mediaQuery] items]) {
		CGFloat durationHelp = [song playbackDuration];
		int duration = (int)durationHelp;
		totalSecs = totalSecs + duration;
	}
	return totalSecs;
}
%new
- (NSString *)playDuration {
	NSUInteger elapsedSeconds = (NSUInteger)[self totalPlayTimeInSeconds];
	NSUInteger h = elapsedSeconds / 3600;
	NSUInteger m = (elapsedSeconds / 60) % 60;
	NSUInteger s = elapsedSeconds % 60;
	if (h < 1) {
		return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)m, (unsigned long)s];
	}
	else return  [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s];
}
%end

%hook MusicCoalescingEntityValueProvider
%new
- (int)totalPlayTimeInSeconds {
	int totalSecs = 0;
	for (MPMediaItem *song in [[[self baseEntityValueProvider] itemsQuery] items]) {
		CGFloat durationHelp = [song playbackDuration];
		int duration = (int)durationHelp;
		totalSecs = totalSecs + duration;
	}
	return totalSecs;
}
%new
- (NSString *)playDuration {
	NSUInteger elapsedSeconds = (NSUInteger)[self totalPlayTimeInSeconds];
	NSUInteger h = elapsedSeconds / 3600;
	NSUInteger m = (elapsedSeconds / 60) % 60;
	NSUInteger s = elapsedSeconds % 60;
	if (h < 1) {
		return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)m, (unsigned long)s];
	}
	else return  [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s];
}
%end

%hook MusicEntityProductHeaderLockupView
%property (nonatomic, retain) UILabel *durationLabel;
- (void)layoutSubviews {
	%orig;
	if (!self.durationLabel) {
	MPUTextDrawingView *bestView = nil;
	for (id subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"MPUTextDrawingView")]) {
            bestView = subview;
        }
    }
    NSString *durationText;
    if ([[self delegate] isKindOfClass:NSClassFromString(@"MusicMediaProductHeaderContentViewController")]) {
    	MusicMediaProductHeaderContentViewController *productController = [self delegate];
    	if ([[productController containerEntityProvider] isKindOfClass:NSClassFromString(@"MusicMediaEntityProvider")]) {
    		MusicMediaEntityProvider *entityProvider = [productController containerEntityProvider];
    		durationText = [entityProvider playDuration];
    	}
    }
    if ([[self entityValueProvider] isKindOfClass:NSClassFromString(@"MusicStorePlaylistEntityValueProvider")]) {
    		MusicStorePlaylistEntityValueProvider *entityProvider = [self entityValueProvider];
    		durationText = [entityProvider playDuration2];
    }
    self.durationLabel = [[UILabel alloc] init];
	self.durationLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:11];
	self.durationLabel.text = [NSString stringWithFormat:@" \u2022 %@", durationText];
	self.durationLabel.textColor = (UIColor *)[[[bestView textDrawingContext] uniformTextAttributes] objectForKey:@"NSColor"];
	self.durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.durationLabel];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.durationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bestView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.durationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bestView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.durationLabel.leadingAnchor constraintEqualToAnchor:bestView.trailingAnchor  constant: 8.0].active = true;
}
else {
	MPUTextDrawingView *bestView = nil;
	for (id subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"MPUTextDrawingView")]) {
            bestView = subview;
        }
    }
    NSString *durationText;
    if ([[self delegate] isKindOfClass:NSClassFromString(@"MusicMediaProductHeaderContentViewController")]) {
    	MusicMediaProductHeaderContentViewController *productController = [self delegate];
    	if ([[productController containerEntityProvider] isKindOfClass:NSClassFromString(@"MusicMediaEntityProvider")]) {
    		MusicMediaEntityProvider *entityProvider = [productController containerEntityProvider];
    		durationText = [entityProvider playDuration];
    	}
    }
    if ([[self entityValueProvider] isKindOfClass:NSClassFromString(@"MusicStorePlaylistEntityValueProvider")]) {
    		MusicStorePlaylistEntityValueProvider *entityProvider = [self entityValueProvider];
    		durationText = [entityProvider playDuration2];
    }
    self.durationLabel.text = [NSString stringWithFormat:@" \u2022 %@", durationText];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.durationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bestView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.durationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bestView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

}
}
%end

%hook  MusicEntityHorizontalLockupView
%property (nonatomic, retain) UILabel *durationLabel;
- (void)layoutSubviews {
	%orig;
	if (!self.durationLabel) {
	MPUTextDrawingView *bestView = nil;
	for (id subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"MPUTextDrawingView")]) {
            bestView = subview;
        }
    }
    NSString *durationText;
    if ([[self entityValueProvider] isKindOfClass:NSClassFromString(@"MusicCoalescingEntityValueProvider")]) {
    		MusicCoalescingEntityValueProvider *entityProvider = [self entityValueProvider];
    		durationText = [entityProvider playDuration];
    }
    self.durationLabel = [[UILabel alloc] init];
	self.durationLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:11];
	self.durationLabel.text = [NSString stringWithFormat:@" \u2022 %@", durationText];
	self.durationLabel.textColor = (UIColor *)[[[bestView textDrawingContext] uniformTextAttributes] objectForKey:@"NSColor"];
	self.durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[bestView addSubview:self.durationLabel];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.durationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bestView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.durationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bestView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.durationLabel.leadingAnchor constraintEqualToAnchor:bestView.trailingAnchor  constant: 8.0].active = true;
}
else {
	MPUTextDrawingView *bestView = nil;
	for (id subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"MPUTextDrawingView")]) {
            bestView = subview;
        }
    }

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.durationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bestView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.durationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bestView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}
}
%end