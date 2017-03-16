if ([[[self icon] applicationBundleID] isEqualToString:@"com.apple.Music"]) {

				//self.clipsToBounds = YES;
				if (!self.playController)
				self.playController = [[%c(MPUNowPlayingController) alloc] init];
				[self.playController setShouldUpdateNowPlayingArtwork:YES];
				[self.playController _updateCurrentNowPlaying];

				_UIBackdropViewSettings *blurSettings= [_UIBackdropViewSettings MPU_settingsForNowPlayingBackdrop];
				MPUBlurEffectView *blurView = [[%c(MPUBlurEffectView) alloc] initWithFrame:CGRectZero];
				[blurView setEffectSettings:blurSettings];
				[blurView setEffectImage:[self updateArtwork]];
				[blurView setReferenceView:blurView];
				blurView.translatesAutoresizingMaskIntoConstraints = NO;
				viewTemp.clipsToBounds = YES;
				blurView.clipsToBounds = YES;
				[viewTemp addSubview:blurView];

				[self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:2 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
				

				MPUVibrantContentEffectView *contentView1 = [[%c(MPUVibrantContentEffectView) alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
				[contentView1 setReferenceView:blurView];
				[contentView1 setEffectImage:[self updateArtwork]];
				[contentView1 setEffectSettings:[_UIBackdropViewSettings MPU_settingsForNowPlayingVibrantContent]];
				contentView1.translatesAutoresizingMaskIntoConstraints = NO;

				[viewTemp addSubview:contentView1];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:2 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];


				UIImageView *artworkView = [[UIImageView alloc] initWithImage:[UIImage imageWithImage:[self.playController currentNowPlayingArtwork] scaledToSize:CGSizeMake(self.frame.size.height, self.frame.size.height)]];
				artworkView.translatesAutoresizingMaskIntoConstraints = NO;
				artworkView.clipsToBounds = YES;

				[viewTemp addSubview:artworkView];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
			
				// UIView *buddy = [[UIView alloc] init];
				// buddy.backgroundColor = [UIColor clearColor];
				// buddy.clipsToBounds = YES;
				// [[contentView1.contentView superview] addSubview:buddy];
				// [contentView1 setValue:buddy forKey:@"contentView"];

				MPUMediaControlsTitlesView *titles = [[NSClassFromString(@"MPUMediaControlsTitlesView") alloc] initWithMediaControlsStyle:0];
				[contentView1.contentView addSubview:titles];
				titles.frame = CGRectMake(0,(self.frame.size.height+40)/2,self.frame.size.width - self.frame.size.height-30, 40);
				titles.center = CGPointMake((self.frame.size.width-self.frame.size.height)/2, self.frame.size.height/2);
				[titles updateTrackInformationWithNowPlayingInfo:[self.playController currentNowPlayingInfo]];
			}


%new
- (void)fixLabels {
	self.songLabel.translatesAutoresizingMaskIntoConstraints = NO;
				self.songLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:17];
				self.songLabel.text = (NSString *)[[self.playController currentNowPlayingInfo] objectForKey:@"kMRMediaRemoteNowPlayingInfoTitle"];
				self.songLabel.textColor = [UIColor whiteColor];
				//self.songLabel.opaque = NO;
				//self.songLabel.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithName:@"plusD"];
				[[self.songLabel superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.songLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self.songLabel superview] attribute:NSLayoutAttributeLeft multiplier:1 constant:40]];
				[[self.songLabel superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.songLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self.songLabel superview] attribute:NSLayoutAttributeCenterY multiplier:1 constant:2]];
				
				self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
				self.artistLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:12];
				self.artistLabel.text = (NSString *)[[self.playController currentNowPlayingInfo] objectForKey:@"kMRMediaRemoteNowPlayingInfoArtist"];
				self.artistLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
				//self.artistLabel.opaque = NO;
				//self.artistLabel.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithName:@"plusD"];
				[[self.artistLabel superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.artistLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self.artistLabel superview] attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
				[[self.artistLabel superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.artistLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.songLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}
%new
- (UIImage *)updateArtwork {
	if (!self.playController) self.playController = [[%c(MPUNowPlayingController) alloc] init];
			[self.playController setShouldUpdateNowPlayingArtwork:YES];
			[self.playController _updateCurrentNowPlaying];
			
			return [UIImage imageWithImage:[self.playController currentNowPlayingArtwork] scaledToSize:CGSizeMake(self.frame.size.width-self.frame.size.height, self.frame.size.width-self.frame.size.height)];
}



f ([[[self icon] applicationBundleID] isEqualToString:@"com.apple.Music"]) {

				//self.clipsToBounds = YES;
				if (!self.playController)
				self.playController = [[%c(MPUNowPlayingController) alloc] init];
				[self.playController setShouldUpdateNowPlayingArtwork:YES];
				[self.playController _updateCurrentNowPlaying];

				_UIBackdropViewSettings *blurSettings= [_UIBackdropViewSettings MPU_settingsForNowPlayingBackdrop];
				MPUBlurEffectView *blurView = [[%c(MPUBlurEffectView) alloc] initWithFrame:CGRectZero];
				[blurView setEffectSettings:blurSettings];
				[blurView setEffectImage:[self updateArtwork]];
				[blurView setReferenceView:blurView];
				blurView.translatesAutoresizingMaskIntoConstraints = NO;
				viewTemp.clipsToBounds = YES;
				blurView.clipsToBounds = YES;
				[viewTemp addSubview:blurView];

				[self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:2 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
				

				MPUVibrantContentEffectView *contentView1 = [[%c(MPUVibrantContentEffectView) alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
				[contentView1 setReferenceView:blurView];
				[contentView1 setEffectImage:[self updateArtwork]];
				[contentView1 setEffectSettings:[_UIBackdropViewSettings MPU_settingsForNowPlayingVibrantContent]];
				contentView1.translatesAutoresizingMaskIntoConstraints = NO;

				[viewTemp addSubview:contentView1];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:2 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];


				UIImageView *artworkView = [[UIImageView alloc] initWithImage:[UIImage imageWithImage:[self.playController currentNowPlayingArtwork] scaledToSize:CGSizeMake(self.frame.size.height, self.frame.size.height)]];
				artworkView.translatesAutoresizingMaskIntoConstraints = NO;
				artworkView.clipsToBounds = YES;

				[viewTemp addSubview:artworkView];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:-1]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
			
				// UIView *buddy = [[UIView alloc] init];
				// buddy.backgroundColor = [UIColor clearColor];
				// buddy.clipsToBounds = YES;
				// [[contentView1.contentView superview] addSubview:buddy];
				// [contentView1 setValue:buddy forKey:@"contentView"];

				MPUMediaControlsTitlesView *titles = [[NSClassFromString(@"MPUMediaControlsTitlesView") alloc] initWithMediaControlsStyle:0];
				[contentView1.contentView addSubview:titles];
				titles.frame = CGRectMake(0,(self.frame.size.height+40)/2,self.frame.size.width - self.frame.size.height-30, 40);
				titles.center = CGPointMake((self.frame.size.width-self.frame.size.height)/2, self.frame.size.height/2);
				[titles updateTrackInformationWithNowPlayingInfo:[self.playController currentNowPlayingInfo]];
			}
			if ([[[self icon] applicationBundleID] isEqualToString:@"com.apple.Maps"]) {
				self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 200,200)];
            	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"/var/mobile/Library/Widgets/FlipDate8/Widget.html"]]];
            	self.webView.backgroundColor = [UIColor clearColor];
            	self.webView.opaque = NO;
            	self.webView.scrollView.scrollEnabled = NO;
            	self.webView.scrollView.scrollsToTop = NO;
            	self.webView.scrollView.showsHorizontalScrollIndicator = NO;
            	self.webView.scrollView.showsVerticalScrollIndicator = NO;
            	self.webView.scrollView.minimumZoomScale = 1.0;
            	self.webView.scrollView.maximumZoomScale = 1.0;
            	self.webView.scalesPageToFit = NO;
            	self.webView.suppressesIncrementalRendering = YES;
           	 	[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 1.0;"];
           		[self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
            	[self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
            	[viewTemp addSubview:self.webView];
			}