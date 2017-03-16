//
//  IBKPanelCell.m
//  curago
//
//  Created by Matt Clarke on 22/02/2015.
//
//

#import "IBKPanelCell.h"

@implementation IBKPanelCell

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"panelCell" specifier:specifier];
    if (self) {
        UICollectionViewFlowLayout* launchpadLayout = [[UICollectionViewFlowLayout alloc] init];
        launchpadLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        launchpadLayout.minimumLineSpacing = 20;
        launchpadLayout.minimumInteritemSpacing = 20;
        
        self.contr = [[IBKPanelViewController alloc] initWithCollectionViewLayout:launchpadLayout];
        self.contr.collectionView.backgroundColor = [UIColor clearColor];
        self.contr.collectionView.opaque = NO;
        self.contr.collectionView.showsVerticalScrollIndicator = NO;
        self.contr.collectionView.bounces = NO;
        self.contr.collectionView.clipsToBounds = NO;
        
        self.contr.collectionView.dataSource = self.contr;
        self.contr.collectionView.delegate = self.contr;
        
        self.contr.collectionView.frame = CGRectMake(0, 0, 0, 0);
        
        [self.contr.collectionView registerClass:[IBKPanelCollectionCell class] forCellWithReuseIdentifier:@"panelCell"];
        
        [self addSubview:self.contr.collectionView];
    }
    
    return self;
}

-(CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return arg1;
}

-(void)dealloc {
    self.contr.collectionView.delegate = nil;
    self.contr.collectionView.dataSource = nil;
    
    [self.contr.collectionView removeFromSuperview];
    [self.contr removeFromParentViewController];
    
    self.contr = nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contr.collectionView.frame = CGRectMake(30, 40, self.bounds.size.width-60, self.bounds.size.height-60);
    [self.contr.collectionView reloadData];
}

@end
