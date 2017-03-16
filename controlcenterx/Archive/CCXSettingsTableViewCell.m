#import "CCXSettingsTableViewCell.h"

@implementation CCXSettingsTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
 
    if (self) {
    	self.backgroundColor = nil;
        // Helpers
	    self.backgroundGlyphView = [[CCXNonTransparentView alloc] initWithFrame:CGRectMake(0,0,29,29)];
	   // self.backgroundGlyphView.backgroundColor = [panel primaryColorForSectionIdentifier:sectionIdentifier] ? [panel primaryColorForSectionIdentifier:sectionIdentifier] : [UIColor colorWithWhite:0.55 alpha:1];
	    self.backgroundGlyphView.layer.cornerRadius = 7;
	    self.backgroundGlyphView.clipsToBounds = YES;
	    self.backgroundGlyphView.tag = 34;

	    CCUIControlCenterVisualEffect *effect = [NSClassFromString(@"CCUIControlCenterVisualEffect")  _primaryRegularTextOnPlatterEffect];
	    _UIVisualEffectConfig *effectConfig = [effect effectConfig];
	   	self.primaryEffectConfig = effectConfig.contentConfig;

    	[self.contentView addSubview:self.backgroundGlyphView];
    	if (self.imageView) {
    		self.backgroundGlyphView.center = self.imageView.center;

		    if (self.contentView && self.imageView && [self.backgroundGlyphView superview]) {
		    	
		    	self.backgroundGlyphView.translatesAutoresizingMaskIntoConstraints = NO;
		    	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundGlyphView
				                                             attribute:NSLayoutAttributeCenterY
				                                             relatedBy:NSLayoutRelationEqual
				                                                toItem:self.imageView
				                                             attribute:NSLayoutAttributeCenterY
				                                             multiplier:1
				                                               constant:0]];
		    	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundGlyphView
				                                             attribute:NSLayoutAttributeCenterX
				                                             relatedBy:NSLayoutRelationEqual
				                                                toItem:self.imageView
				                                             attribute:NSLayoutAttributeCenterX
				                                             multiplier:1
				                                               constant:0]];
		    	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundGlyphView
				                                             attribute:NSLayoutAttributeWidth
				                                             relatedBy:NSLayoutRelationEqual
				                                                toItem:nil
				                                             attribute:NSLayoutAttributeNotAnAttribute
				                                             multiplier:1
				                                               constant:29]];
		    	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundGlyphView
				                                             attribute:NSLayoutAttributeHeight
				                                             relatedBy:NSLayoutRelationEqual
				                                                toItem:nil
				                                             attribute:NSLayoutAttributeNotAnAttribute
				                                             multiplier:1
				                                               constant:29]];
		    }
		}
		[self.contentView sendSubviewToBack:self.backgroundGlyphView];
    }
    return self;
}

- (void)setIconColor:(UIColor *)color {
	if (color != _iconColor) {
		if (self.backgroundGlyphView) {
			_iconColor = color;
			self.backgroundGlyphView.backgroundColor = _iconColor;
		} else {
			[self layoutGlyphBackgroundView];
			if (self.backgroundGlyphView) {
				self.backgroundGlyphView.backgroundColor = _iconColor;
			}
		}
	}
}

- (UIColor *)iconColor {
	return _iconColor;
}

- (void)layoutGlyphBackgroundView {
	if (!self.backgroundGlyphView) {
		self.backgroundGlyphView = [[CCXNonTransparentView alloc] initWithFrame:CGRectMake(0,0,29,29)];
	   // self.backgroundGlyphView.backgroundColor = [panel primaryColorForSectionIdentifier:sectionIdentifier] ? [panel primaryColorForSectionIdentifier:sectionIdentifier] : [UIColor colorWithWhite:0.55 alpha:1];
	    self.backgroundGlyphView.layer.cornerRadius = 7;
	    self.backgroundGlyphView.clipsToBounds = YES;
	    self.backgroundGlyphView.tag = 34;

    	[self.contentView addSubview:self.backgroundGlyphView];
    	if (self.imageView) {
    		self.imageView.tintColor = [UIColor whiteColor];
    		self.backgroundGlyphView.center = self.imageView.center;

		    if (self.contentView && self.imageView && [self.backgroundGlyphView superview]) {
		    	
		    	self.backgroundGlyphView.translatesAutoresizingMaskIntoConstraints = NO;
		    	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundGlyphView
				                                             attribute:NSLayoutAttributeCenterY
				                                             relatedBy:NSLayoutRelationEqual
				                                                toItem:self.imageView
				                                             attribute:NSLayoutAttributeCenterY
				                                             multiplier:1
				                                               constant:0]];
		    	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundGlyphView
				                                             attribute:NSLayoutAttributeCenterX
				                                             relatedBy:NSLayoutRelationEqual
				                                                toItem:self.imageView
				                                             attribute:NSLayoutAttributeCenterX
				                                             multiplier:1
				                                               constant:0]];
		    	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundGlyphView
				                                             attribute:NSLayoutAttributeWidth
				                                             relatedBy:NSLayoutRelationEqual
				                                                toItem:nil
				                                             attribute:NSLayoutAttributeNotAnAttribute
				                                             multiplier:1
				                                               constant:29]];
		    	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundGlyphView
				                                             attribute:NSLayoutAttributeHeight
				                                             relatedBy:NSLayoutRelationEqual
				                                                toItem:nil
				                                             attribute:NSLayoutAttributeNotAnAttribute
				                                             multiplier:1
				                                               constant:29]];
		    }
		}
	}
	[self.contentView sendSubviewToBack:self.backgroundGlyphView];
}

-(UIView *)findReorderView:(UIView *)view
{
    UIView *reorderView = nil;
    for (UIView *subview in view.subviews)
    {
        if ([[[subview class] description] rangeOfString:@"Reorder"].location != NSNotFound)
        {
            reorderView = subview;
            break;
        }
        else
        {
            reorderView = [self findReorderView:subview];
            if (reorderView != nil)
            {
                break;
            }
        }
    }
    return reorderView;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        UIView *reorderView = [self findReorderView:self];
        if (reorderView) {
            for (UIView *sv in reorderView.subviews) {
                if ([sv isKindOfClass:[UIImageView class]]) {
                    ((UIImageView *)sv).image = [((UIImageView *)sv).image  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
					((UIImageView *)sv).tintColor = [UIColor whiteColor];
					[self.primaryEffectConfig configureLayerView:(UIImageView *)sv];
                }
            }
        }
    }
}

- (UIEdgeInsets)layoutMargins {
	return UIEdgeInsetsZero;
}

- (void)setLayoutMargins:(UIEdgeInsets)insets {
	[super setLayoutMargins:UIEdgeInsetsZero];
}

- (UIEdgeInsets)separatorInset {
	return UIEdgeInsetsZero;
}

- (void)setSeparatorInset:(UIEdgeInsets)inset {
	[super setSeparatorInset:UIEdgeInsetsZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   	if (self.backgroundGlyphView)
   		self.backgroundGlyphView.backgroundColor = _iconColor;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.backgroundColor = nil;

	if (!self.backgroundGlyphView) {
		[self layoutGlyphBackgroundView];
	}
	if (self.backgroundGlyphView) {
		[self.contentView sendSubviewToBack:self.backgroundGlyphView];
	}

	for (UIView *view in [self subviews]) {
		if (view.frame.size.width == 0.5) {
			view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
		}
	}
	if (self.imageView) {
		self.imageView.tintColor = [UIColor whiteColor];
		self.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
	}
	if ([self valueForKey:@"_editingAccessoryView"])
    	[self.primaryEffectConfig configureLayerView:[self valueForKey:@"_editingAccessoryView"]];
}
@end
