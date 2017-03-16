#import <Foundation/NSObject.h>

@class SBDeckSwitcherItemContainer;

@protocol SBDeckSwitcherItemContainerDelegate <NSObject>
- (double)minimumVerticalTranslationForKillingOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (void)scrollViewKillingProgressUpdated:(double)arg1 ofContainer:(SBDeckSwitcherItemContainer *)arg2;
- (CGRect)frameForPageViewOfContainer:(SBDeckSwitcherItemContainer *)arg1 fullyPresented:(BOOL)arg2;
- (void)selectedDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (BOOL)canSelectDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 numberOfTaps:(long long)arg2;
- (void)killDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 withVelocity:(double)arg2;
- (BOOL)shouldShowIconAndLabelOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (BOOL)isDisplayItemOfContainerRemovable:(SBDeckSwitcherItemContainer *)arg1;
@end