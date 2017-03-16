#import <UIKit/UIView.h>
#import <MediaPlayerUI/MPUTransportControlsViewDataSource-Protocol.h>
#import <MediaPlayerUI/MPUTransportControlsViewDelegate-Protocol.h>
#import <MediaPlayerUI/MPUTransportControlsViewLayoutDelegate-Protocol.h>

@interface MPUTransportControlsView : UIView {

	NSMutableDictionary* _classByReuseIdentifier;
	UIEdgeInsets _insetsForExpandingButtons;
	BOOL _sortedVisibleControlsWithBlanksNeedsReload;
	BOOL _sortByGroup;
	NSMutableDictionary* _recycledButtonsByReuseIdentifier;
	NSMapTable* _reuseIdentifierByButton;
	NSMutableArray* _sortedVisibleControlsWithBlanks;
	NSMutableSet* _typesOfControlsToReload;
	NSMutableDictionary* _visibleButtonByControlType;
	BOOL _usesLegacyLayoutHeuristics;
	NSArray* _availableTransportControls;
	id<MPUTransportControlsViewDataSource> _dataSource;
	id<MPUTransportControlsViewDelegate> _delegate;
	id<MPUTransportControlsViewLayoutDelegate> _layoutDelegate;
	NSUInteger _minimumNumberOfTransportButtonsForLayout;

}

@property (assign,setter=_setInsetsForExpandingButtons:,getter=_insetsForExpandingButtons,nonatomic) UIEdgeInsets insetsForExpandingButtons; 
@property (assign,setter=_setUsesLegacyLayoutHeuristics:,getter=_usesLegacyLayoutHeuristics,nonatomic) BOOL usesLegacyLayoutHeuristics;                   //@synthesize usesLegacyLayoutHeuristics=_usesLegacyLayoutHeuristics - In the implementation block
@property (nonatomic,copy) NSArray * availableTransportControls;                                                                                          //@synthesize availableTransportControls=_availableTransportControls - In the implementation block
@property (assign,nonatomic) id<MPUTransportControlsViewDataSource> dataSource;                                                                    //@synthesize dataSource=_dataSource - In the implementation block
@property (assign,nonatomic) id<MPUTransportControlsViewDelegate> delegate;                                                                        //@synthesize delegate=_delegate - In the implementation block
@property (assign,nonatomic) id<MPUTransportControlsViewLayoutDelegate> layoutDelegate;                                                            //@synthesize layoutDelegate=_layoutDelegate - In the implementation block
@property (assign,nonatomic) NSUInteger minimumNumberOfTransportButtonsForLayout;                                                                 //@synthesize minimumNumberOfTransportButtonsForLayout=_minimumNumberOfTransportButtonsForLayout - In the implementation block
@property (assign,nonatomic) BOOL sortByGroup;                                                                                                            //@synthesize sortByGroup=_sortByGroup - In the implementation block
+(id)defaultTransportControls;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(void)setDataSource:(id<MPUTransportControlsViewDataSource>)arg1 ;
-(void)setDelegate:(id<MPUTransportControlsViewDelegate>)arg1 ;
// -(void)dealloc;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(id<MPUTransportControlsViewDataSource>)dataSource;
-(id<MPUTransportControlsViewDelegate>)delegate;
-(void)setAvailableTransportControls:(NSArray *)arg1 ;
-(void)_willRemoveTransportButton:(id)arg1 ;
-(void)_recycleTransportButtonWithControlType:(NSInteger)arg1 ;
-(void)_reloadSortedVisibleControlsWithBlanks;
-(id)_typesOfVisibleControls;
-(id)_visibleTransportControlAtIndex:(NSUInteger)arg1 ;
-(void)_configureTransportButton:(id)arg1 forTransportControl:(id)arg2 ;
-(CGSize)_transportControlButtonSize;
-(CGRect)_adjustedFrameOfButtonForTransportControl:(id)arg1 proposedFrame:(CGRect)arg2 ;
-(id)_typesFromTransportControls:(id)arg1 ;
-(void)reloadTransportButtonWithControlType:(NSInteger)arg1 ;
-(id)_createTransportButtonWithReuseIdentifier:(id)arg1 ;
-(void)_transportControlLongPressBegan:(id)arg1 ;
-(void)_transportControlLongPressEnded:(id)arg1 ;
-(void)_transportControlTapped:(id)arg1 ;
-(void)_transportControlTouchEntered:(id)arg1 ;
-(void)_transportControlTouchExited:(id)arg1 ;
-(id)_availableTransportControlsForGroup:(int)arg1 ;
-(id)availableTransportControlWithType:(NSInteger)arg1 ;
-(void)setSortByGroup:(BOOL)arg1 ;
-(id)dequeueReusableTransportButtonWithReuseIdentifier:(id)arg1 ;
-(void)registerClass:(Class)arg1 forTransportButtonWithReuseIdentifier:(id)arg2 ;
-(id)_transportButtonForControlType:(NSInteger)arg1 ;
-(void)setMinimumNumberOfTransportButtonsForLayout:(NSUInteger)arg1 ;
-(UIEdgeInsets)_insetsForExpandingButtons;
-(void)_setInsetsForExpandingButtons:(UIEdgeInsets)arg1 ;
-(void)_setUsesLegacyLayoutHeuristics:(BOOL)arg1 ;
-(NSArray *)availableTransportControls;
-(NSUInteger)minimumNumberOfTransportButtonsForLayout;
-(BOOL)sortByGroup;
-(BOOL)_usesLegacyLayoutHeuristics;
-(void)setLayoutDelegate:(id<MPUTransportControlsViewLayoutDelegate>)arg1 ;
-(id<MPUTransportControlsViewLayoutDelegate>)layoutDelegate;
@end
