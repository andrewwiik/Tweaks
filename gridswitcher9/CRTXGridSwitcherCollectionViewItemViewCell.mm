#import "headers/headers.h"
#import "CRTXGridSwitcherCollectionViewItemViewCell.h"

@interface CRTXGridSwitcherCollectionViewItemViewCell () {

    SBDeckSwitcherItemContainer *_itemContainer;
}
    
@end

@implementation CRTXGridSwitcherCollectionViewItemViewCell

- (void)setSwitcherItem:(SBDeckSwitcherItemContainer *)item {
    if (_itemContainer) {
    }
    else {
    _itemContainer = item;
    _itemContainer.transform = CGAffineTransformMakeScale(self.frame.size.width/_itemContainer.frame.size.width, self.frame.size.height/_itemContainer.frame.size.height);
    [self addSubview:_itemContainer];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end