//
//  IBKPanelCollectionCell.h
//  curago
//
//  Created by Matt Clarke on 22/02/2015.
//
//

#import <UIKit/UIKit.h>

@interface IBKPanelCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIView *highlight;
@property (nonatomic, strong) UIView *bgView;

-(void)initialiseWithImageName:(NSString*)imgName andTitle:(NSString*)title andIndex:(int)index;

@end
