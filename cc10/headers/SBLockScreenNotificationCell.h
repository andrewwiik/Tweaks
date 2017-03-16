#import "SBLockScreenNotificationListView.h"

@class SBLockScreenNotificationCell;
@class SBLockScreenActionContext;
@interface SBLockScreenNotificationCell : UITableViewCell
@property (assign,nonatomic) SBLockScreenNotificationListView *delegate;
@property (assign,nonatomic) BOOL isTopCell;                                                   //@synthesize isTopCell=_isTopCell - In the implementation block
@property (assign,nonatomic) CGFloat contentScrollViewWidth;                                    //@synthesize contentScrollViewWidth=_contentScrollViewWidth - In the implementation block             //@synthesize lockScreenActionContext=_lockScreenActionContext - In the implementation block
@property (nonatomic,readonly) UIScrollView * contentScrollView;                               //@synthesize contentScrollView=_contentScrollView - In the implementation block
@property (assign,nonatomic) BOOL resetsScrollOnPluginWillDisable;                             //@synthesize resetsScrollOnPluginWillDisable=_resetsScrollOnPluginWillDisable - In the implementation block
@property (nonatomic,retain) SBLockScreenActionContext * lockScreenActionContext;  
+(id)defaultColorForRelevanceDate;
+(id)defaultColorForEventDate;
+(id)defaultColorForPrimaryText;
+(id)defaultColorForSubtitleText;
+(id)defaultColorForSecondaryText;
+(BOOL)wantsUnlockActionText;
+(CGFloat)unlockLineBaselineOffsetFromPreviousLine;
+(CGFloat)rowHeightForTitle:(id)arg1 subtitle:(id)arg2 body:(id)arg3 maxLines:(unsigned long long)arg4 attachmentSize:(CGSize)arg5 secondaryContentSize:(CGSize)arg6 datesVisible:(BOOL)arg7 rowWidth:(CGFloat)arg8 includeUnlockActionText:(BOOL)arg9 ;
+(CGFloat)lastLineBottomPadding;
-(BOOL)shouldVerticallyCenterContent;
-(void)setRelevanceDateLabel:(id)arg1 ;
-(id)_secondaryContentView;
-(void)setResetsScrollOnPluginWillDisable:(BOOL)arg1 ;
-(void)_notePluginWillDisable:(id)arg1 ;
-(void)scrollToOriginAnimated:(BOOL)arg1 ;
-(id)_vibrantTextColor;
-(void)_updateUnlockText:(id)arg1 ;
-(id)_buttonWithLabel:(id)arg1 ;
-(void)_handleActionButtonPress:(id)arg1 ;
-(CGFloat)_unlockTextOriginY;
-(void)resetScrollView;
-(void)setContentScrollViewWidth:(CGFloat)arg1 ;
-(void)setIsTopCell:(BOOL)arg1 ;
-(void)setButtonLabel:(id)arg1 handler:(id)arg2 ;
-(BOOL)shouldAnimateHintForTouchInCell:(CGPoint)arg1 ;
-(CGFloat)contentScrollViewWidth;
-(BOOL)resetsScrollOnPluginWillDisable;
-(void)dealloc;
-(void)layoutSubviews;
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 ;
-(void)prepareForReuse;
-(long long)_separatorBackdropOverlayBlendMode;
-(void)_setSeparatorBackdropOverlayBlendMode:(long long)arg1 ;
-(UIScrollView *)contentScrollView;
-(BOOL)isTopCell;
-(void)setContentAlpha:(CGFloat)arg1 ;
@end