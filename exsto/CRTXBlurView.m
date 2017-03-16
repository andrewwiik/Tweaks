#import "CRTXBlurView.h"

typedef void(^CRTXBlurViewBlurCompletion)(BOOL);

@interface CRTXBlurView ()
@property (nonatomic, retain) _UIBackdropViewSettings *fullBlurSettings;
@property (nonatomic, retain) _UIBackdropViewSettings *noBlurSettings;
@property (nonatomic, retain) _UIBackdropView *backgroundBlurView;
@property (nonatomic, assign) CGFloat backgroundBlurProgress;
- (void)animateBackgroundBlurFromWeight:(CGFloat)startWeight toWeight:(CGFloat)endWeight withDuration:(CGFloat)duration withCompletion:(CRTXBlurViewBlurCompletion)completion;
@end

@implementation CRTXBlurView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    	self.fullBlurSettings= [_UIBackdropViewSettings settingsForStyle:2020];
        self.fullBlurSettings.blurRadius = 15.0;
        self.fullBlurSettings.grayscaleTintAlpha = 0.05;
        self.fullBlurSettings.colorTint = [UIColor blackColor];
        self.fullBlurSettings.colorTintAlpha = 0.07;

        self.noBlurSettings = [_UIBackdropViewSettings settingsForStyle:-2];
        // self.noBlurSettings.blurRadius = 0;
        // self.noBlurSettings.grayscaleTintAlpha = 0.05;
        // self.noBlurSettings.colorTint = [UIColor blackColor];
        // self.noBlurSettings.colorTintAlpha = 0.07;
// 
        self.backgroundBlurView = [[_UIBackdropView alloc] initWithSettings:self.noBlurSettings];
        self.contentView = self.backgroundBlurView.contentView;
        [self.backgroundBlurView setAppliesOutputSettingsAnimationDuration:0];

    }
    return self;
}
- (void)layoutSubviews {
	[super layoutSubviews];
	if (![[self subviews] containsObject:self.backgroundBlurView]) {

		[self addSubview:self.backgroundBlurView];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	}
}
- (void)animateBackgroundBlurFromWeight:(CGFloat)startWeight toWeight:(CGFloat)endWeight withDuration:(CGFloat)duration withCompletion:(CRTXBlurViewBlurCompletion)completion {
    if (self.fullBlurSettings && self.backgroundBlurView) {
        
        POPBasicAnimation *anim = [POPBasicAnimation animation];
        POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"com.creatix.CRTXBlurView.blur" initializer:^(POPMutableAnimatableProperty *prop) {
        
            prop.readBlock = ^(CRTXBlurView *obj, CGFloat values[]) {

              values[0] = [obj backgroundBlurProgress];
            };
        
            prop.writeBlock = ^(CRTXBlurView *obj, const CGFloat values[]) {

              [obj setBackgroundBlurProgress:values[0]];
              _UIBackdropViewSettings *settings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:2020];
              [settings setBlurRadius:15.0];
              self.fullBlurSettings = settings;

              settings.grayscaleTintAlpha = 0.05;
              settings.colorTint = [UIColor blackColor];
              settings.colorTintAlpha = 0.07;
              //obj.fullBlurSettings.blurRadius = 15*values[0];
              [obj.backgroundBlurView transitionIncrementallyToSettings:settings weighting:values[0]];
            };

            prop.threshold = 0.01;
        }];

        anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self pop_removeAnimationForKey:@"blur"];
        if (completion)
        	completion(YES);

        };

        anim.property = prop;
        anim.fromValue = @(startWeight);
        anim.toValue = @(endWeight);
        // anim.velocity = @(80.);
        // anim.springBounciness = 0;
        // anim.springSpeed = 20;
        anim.duration = duration;
        [self pop_addAnimation:anim forKey:@"blur"];
    }
}

- (void)updateConstraints {
	[super updateConstraints];
}

- (void)activateBlur {
	[self animateBackgroundBlurFromWeight:0 toWeight:1 withDuration:0.2 withCompletion:nil];
}

- (void)deactivateBlurWithView:(UIView *)view {
	[self animateBackgroundBlurFromWeight:1 toWeight:0 withDuration:0.3 withCompletion:^(BOOL finished) {
    if(finished){
    	[view removeFromSuperview];
        [self removeFromSuperview];
    }
}];
}
@end