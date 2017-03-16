//
//  IBKPanelViewController.m
//  curago
//
//  Created by Matt Clarke on 22/02/2015.
//
//

#import "IBKPanelViewController.h"

@interface IBKPanelViewController ()

@end

@implementation IBKPanelViewController

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IBKPanelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"panelCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            [cell initialiseWithImageName:@"Adjust" andTitle:@"Adjust widgets" andIndex:0];
            break;
            
        case 1:
            [cell initialiseWithImageName:@"Manage" andTitle:@"Manage addons" andIndex:1];
            break;
        
        case 2:
            [cell initialiseWithImageName:@"Advanced" andTitle:@"Advanced options" andIndex:2];
            break;
            
        case 3:
            [cell initialiseWithImageName:@"Support" andTitle:@"FAQ / Support" andIndex:3];
            break;
        
        default:
            break;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.bounds.size.width/2) - 40, (self.view.bounds.size.width/2) - 40);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            // handle "Adjust widgets"
            break;
        case 1:
            // Handle "Manage addons"
            break;
        case 2:
            // Handle "Advanced options"
            break;
        case 3:
            // Handle "FAQ / Support"
            break;
        default:
            break;
    }
}

@end
