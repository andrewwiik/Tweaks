#import <ControlCenterUIKit/CCUIControlCenterButton.h>

@interface CCUIControlCenterPushButton : CCUIControlCenterButton
{
    NSString *_identifier;
    NSNumber *_sortKey;
}

@property(copy, nonatomic) NSNumber *sortKey; // @synthesize sortKey=_sortKey;
@property(copy, nonatomic) NSString *identifier; // @synthesize identifier=_identifier;
- (id)initWithFrame:(CGRect)arg1;
@end