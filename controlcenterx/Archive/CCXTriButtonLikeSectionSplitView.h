#import "headers.h"

@interface CCXTriButtonLikeSectionSplitView : CCUIButtonLikeSectionSplitView
@property (nonatomic, retain) CCUIControlCenterPushButton *middleSection;
@property (nonatomic, retain) CCUIControlCenterPushButton *secondMiddleSection;
- (void)layoutSubviews;
- (CGRect)_frameForSectionSlot:(int)slot;
- (CCUIControlCenterPushButton *)_viewForSectionSlot:(int)slot;
- (void)_updateButtonsCorners;
- (void)addedMiddleSection;
- (void)fixGlyphs;

@end