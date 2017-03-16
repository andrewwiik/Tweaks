#import "headers/headers.h"

@interface CCUIControlCenterButton (CCM)
@property (nonatomic, assign) BOOL preventMaskFromRendering;
@property (nonatomic, retain) UIView *maskingMaterialView;
- (CGFloat)cornerRadius;
@end

@interface CCUISystemControlsPageViewController (CCM)
@property (nonatomic, retain) UIImageView *platterBackgroundView;
@property (nonatomic, retain) NSMutableArray *maskingViews;
@property (nonatomic, retain) NSMutableArray *cutoutViews;
@property (nonatomic, assign) BOOL isUpdatingImages;
- (void)updateCutoutViews;
- (void)updateCutoutImages;
@end

@interface CCUIControlCenterMaterialView : NSObject
+ (UIView *)baseMaterialBlurView;
@end

//static BOOL isMakingBorder = NO;

%hook CCUIControlCenterButton
%property (nonatomic, retain) UIView *maskingMaterialView;
- (id)ccuiPunchOutMaskForView:(UIView *)arg1 {
	if ([self isKindOfClass:NSClassFromString(@"PLFlipswitchButton")]) {
		return nil;
	} else return %orig;
}
- (void)layoutSubviews {
	%orig;
	if ([self isKindOfClass:NSClassFromString(@"PLFlipswitchButton")]) {
		if (!self.maskingMaterialView) {
			self.maskingMaterialView = [NSClassFromString(@"CCUIControlCenterMaterialView") baseMaterialBlurView];
			[self addSubview:self.maskingMaterialView];
			[self sendSubviewToBack:self.maskingMaterialView];
			// [self sendSubviewToBack:self.maskingMaterialView];
			// self.maskingMaterialView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
		}
		if (self.maskingMaterialView) {
			//[self sendSubviewToBack:self.maskingMaterialView];
			self.maskingMaterialView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
			if (self.layer.cornerRadius != [self cornerRadius]) {
				self.layer.cornerRadius = [self cornerRadius];
				self.clipsToBounds = YES;
			}
		}
	}
}
%end

// @interface UIView (CCM)
// @property (nonatomic, assign) BOOL fakeClipsToBounds;
// @end

// @interface UIImage (CCM)
// - (UIImage *)ccuiAlphaOnlyImageForMaskImage;
// @end

// %hook UIView
// %property (nonatomic, assign) BOOL fakeClipsToBounds;
// - (BOOL)clipsToBounds {
// 	if (self.fakeClipsToBounds) {
// 		return NO;
// 	} else return %orig;
// }
// %end

// %hook CCUIControlCenterPagePlatterView
// - (void)_recursivelyVisitSubviewsOfView:(UIView *)view forPunchedThroughView:(UIView *)punchedView collectingMasksIn:(NSMutableArray *)maskArray {
// 	if (view.clipsToBounds)
// 		view.fakeClipsToBounds = YES;
// 	%orig;
// 	view.fakeClipsToBounds = NO;
// }
// %end

// @interface UIStackView (CCM)
// @property (nonatomic, assign) BOOL shouldFakeHidden;
// @property (nonatomic, assign) BOOL shouldGeneratePunchOutMask;
// @end

// %hook UIStackView
// %property (nonatomic, assign) BOOL shouldFakeHidden;
// %property (nonatomic, assign) BOOL shouldGeneratePunchOutMask;

// - (BOOL)isHidden {
// 	return (self.shouldFakeHidden && !self.shouldGeneratePunchOutMask)  ? YES : %orig;
// }

// %new
// - (CCUIPunchOutMask *)ccuiPunchOutMaskForView:(UIView *)view {
// 	if (self.shouldGeneratePunchOutMask) {
// 		if (view) {
// 			return [[NSClassFromString(@"CCUIPunchOutMask") alloc] initWithFrame:[view convertRect:self.bounds fromView:self] style:0 radius:0 roundedCorners:0];
// 		} else {
// 			return [[NSClassFromString(@"CCUIPunchOutMask") alloc] initWithFrame:CGRectZero style:0 radius:0 roundedCorners:0];
// 		}
// 	}
// 	return nil;
// }
// %end


// %hook CCUISystemControlsPageViewController
// %property (nonatomic, retain) UIImageView *platterBackgroundView;
// %property (nonatomic, retain) NSMutableArray *maskingViews;
// %property (nonatomic, retain) NSMutableArray *cutoutViews;
// %property (nonatomic, assign) BOOL isUpdatingImages;

// -(void)loadView {
// 	%orig;
// 	if (!self.maskingViews) {
// 		if ([self valueForKey:@"_horizontalStackView"]) {
// 			UIStackView *stackView = (UIStackView *)[self valueForKey:@"_horizontalStackView"];
// 			if ([stackView superview]) {
// 				if (!self.cutoutViews) {
				
// 					self.maskingViews = [NSMutableArray new];
// 					self.cutoutViews = [NSMutableArray new];
					
// 					if (!self.platterBackgroundView) {
// 						CCUIControlCenterPagePlatterView *platterView = [self.view ccuiPunchOutMaskedContainer];
// 						for (UIView *subview in [platterView subviews]) {
// 							if ([subview isKindOfClass:NSClassFromString(@"UIImageView")]) {
// 								self.platterBackgroundView = (UIImageView *)subview;
// 								[self.platterBackgroundView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
// 								break;
// 							}
// 						}
// 					}
					
// 					if ([self valueForKey:@"_columnStackViews"]) {
// 						NSMutableArray *columnStackViews = (NSMutableArray *)[self valueForKey:@"_columnStackViews"];
// 						for (UIStackView *columnView in columnStackViews) {
// 							UIView *rootView = [[UIView alloc] initWithFrame:self.view.frame];
// 							rootView.backgroundColor = nil;
// 							rootView.alpha = 1.0;
// 							rootView.userInteractionEnabled = NO;
// 							[self.view addSubview:rootView];
// 							[self.maskingViews addObject:rootView];
							
// 							UIView *childView = [[UIView alloc] initWithFrame:[self.view convertRect:columnView.frame fromView:columnView]];
// 							childView.backgroundColor = [UIColor blackColor];
// 							childView.alpha = 1;
// 							[rootView addSubview:childView];
							
// 							UIImageView *cutoutView = [[UIImageView alloc] initWithFrame:self.view.frame];
// 							[self.view addSubview:cutoutView];
// 							[self.cutoutViews addObject:cutoutView];
// 						}

// 						UIImageView *borderView = [[UIImageView alloc] initWithFrame:self.view.frame];
// 						[self.view addSubview:borderView];
// 						[self.cutoutViews addObject:borderView];
// 					}
// 				}
// 			}
// 		}
// 	}
// }

// %new
// - (void)updateCutoutViews {

// 	if (self.cutoutViews && self.maskingViews) {
// 		if (!self.platterBackgroundView) {
// 			CCUIControlCenterPagePlatterView *platterView = [self.view ccuiPunchOutMaskedContainer];
// 			for (UIView *subview in [platterView subviews]) {
// 				if ([subview isKindOfClass:NSClassFromString(@"UIImageView")]) {
// 					self.platterBackgroundView = (UIImageView *)subview;
// 					[self.platterBackgroundView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
// 					break;
// 				}
// 			}
// 		}
		
// 		if (self.platterBackgroundView && [self valueForKey:@"_columnStackViews"]) {
		
// 			NSMutableArray *columnViews = (NSMutableArray *)[self valueForKey:@"_columnStackViews"];
// 			if ([self.maskingViews count] == [self.cutoutViews count]-1 && [self.cutoutViews count]-1 == [columnViews count]) {
// 				for (int z = 0; z < [self.maskingViews count]; z++) {
// 					UIView *rootView = (UIView *)self.maskingViews[z];
// 					UIView *childView;
// 					for (UIView *subview in [rootView subviews]) {
// 						childView = subview;
// 					}
					
// 					if (childView && rootView) {
// 						rootView.frame = self.view.frame;
// 						childView.frame = [self.view convertRect:((UIView *)columnViews[z]).frame fromView:[columnViews[z] superview]];
						
// 						((UIImageView *)self.cutoutViews[z]).layer.mask = rootView.layer;
// 					}
// 				}

// 				for (int z = 0; z < [columnViews count]; z++) {
// 					if (NSClassFromString(@"CCXMainControlsPageViewController")) {
// 	            		if([columnViews count] == 2) {
// 	            			if (z == 1) {
// 	            				((UIStackView *)columnViews[z]).shouldFakeHidden = NO;
// 		                		((UIStackView *)columnViews[z]).shouldGeneratePunchOutMask = NO;
// 	            			} else {
// 	            				((UIStackView *)columnViews[z]).shouldFakeHidden = NO;
// 		                		((UIStackView *)columnViews[z]).shouldGeneratePunchOutMask = YES;
// 	            			}
// 	            		} else {
// 	            			((UIStackView *)columnViews[z]).shouldFakeHidden = NO;
// 		                	((UIStackView *)columnViews[z]).shouldGeneratePunchOutMask = YES;
// 	            		}
// 	            	} else {
// 		                ((UIStackView *)columnViews[z]).shouldFakeHidden = NO;
// 		                ((UIStackView *)columnViews[z]).shouldGeneratePunchOutMask = YES;
// 		            }
//             	}

//             	self.isUpdatingImages = YES;
//             	isMakingBorder = YES;

// 				[[self.view ccuiPunchOutMaskedContainer] _rerenderPunchThroughMaskIfNecessary];

// 	            if ([self.cutoutViews count] > 0) {
// 	                UIImageView *cutoutView = self.cutoutViews[[self.cutoutViews count]-1];
// 	                cutoutView.frame = self.view.frame;
// 	                cutoutView.image = self.platterBackgroundView.image;
// 	                cutoutView.layer.cornerRadius = self.platterBackgroundView.layer.cornerRadius;
// 	                cutoutView.layer.masksToBounds = self.platterBackgroundView.layer.masksToBounds;
// 	                cutoutView.layer.cornerContentsCenter = self.platterBackgroundView.layer.cornerContentsCenter;
// 					cutoutView.layer.contentsMultiplyColor = self.platterBackgroundView.layer.contentsMultiplyColor;
// 					cutoutView._continuousCornerRadius = self.platterBackgroundView._continuousCornerRadius;
// 					[[cutoutView superview] sendSubviewToBack:cutoutView];
// 	            }

// 	            for (int y = 0; y < [columnViews count]; y++) {
	       
// 	                ((UIStackView *)columnViews[y]).shouldGeneratePunchOutMask = NO;
// 	            }
// 	            isMakingBorder = NO;
// 	            self.isUpdatingImages = NO;
// 			}
			
// 			[self updateCutoutImages];
// 		}
// 	}
// }

// // - (void)_updateBackgroundForStateChange {
// // 	%orig;
// // 	if (!NSClassFromString(@"SBCc"))
// // }

// - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//   if ([keyPath isEqualToString:@"image"] && object == self.platterBackgroundView) {
//      [self updateCutoutImages];
//   } else %orig;
// }

// %new
// - (void)updateCutoutImages {
// 	if (self.isUpdatingImages) return;
// 	self.isUpdatingImages = YES;
// 	if (self.cutoutViews) {
// 		if (!self.platterBackgroundView) {
// 			CCUIControlCenterPagePlatterView *platterView = [self.view ccuiPunchOutMaskedContainer];
// 			for (UIView *subview in [platterView subviews]) {
// 				NSLog(@"GOT A SUBVIEW: %@", subview);
// 				if ([subview isKindOfClass:NSClassFromString(@"UIImageView")]) {
// 					self.platterBackgroundView = (UIImageView *)subview;
// 					[self.platterBackgroundView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
// 					break;
// 				}
// 			}
// 		}
		
// 		if (self.platterBackgroundView && [self valueForKey:@"_columnStackViews"]) {

//             NSMutableArray *columnStackViews = [self valueForKey:@"_columnStackViews"];

//             self.platterBackgroundView.hidden = YES;
//             self.platterBackgroundView.alpha = 0;
// 			for (int x = 0; x < [self.cutoutViews count] -1; x++) {
// 				UIImageView *cutoutView = self.cutoutViews[x];
//                 cutoutView.frame = self.view.frame;
               
//                 for (int y = 0; y < [columnStackViews count]; y++) {
//                 	if (y != x) {
//                 		((UIStackView *)columnStackViews[y]).shouldFakeHidden = YES;
//                 	} else {
//                 		((UIStackView *)columnStackViews[y]).shouldFakeHidden = NO;
//                 	}
//                 }
//                 [[self.view ccuiPunchOutMaskedContainer] _rerenderPunchThroughMaskIfNecessary];
//                 cutoutView.image = self.platterBackgroundView.image;
// 				cutoutView.layer.contentsMultiplyColor = self.platterBackgroundView.layer.contentsMultiplyColor;
// 				[[cutoutView superview] sendSubviewToBack:cutoutView];
// 			}

//             for (int y = 0; y < [columnStackViews count]; y++) {
//                 ((UIStackView *)columnStackViews[y]).shouldFakeHidden = NO;

//             }
// 		}
// 	}
// 	self.isUpdatingImages = NO;
// }

// -(void)_updateColumns {
// 	%orig;
// 	[self updateCutoutViews];
// }

// -(void)_updateSectionViews {
// 	%orig;
// 	[self updateCutoutViews];
// }
// -(void)_updateStackViewMarginsAndSpacing {
// 	%orig;
// 	[self updateCutoutViews];
// }

// -(void)viewWillAppear:(BOOL)arg1  {
// 	%orig;
// 	[self updateCutoutViews];
// }

// -(void)_updateAllSectionVisibilityAnimated:(BOOL)arg1 {
// 	%orig;
// 	[self updateCutoutViews];
// }
// %end

