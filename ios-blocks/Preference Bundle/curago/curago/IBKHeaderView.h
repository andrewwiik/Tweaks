//
//  IBKHeaderView.h
//  curago
//
//  Created by Matt Clarke on 26/02/2015.
//
//

#import <UIKit/UIKit.h>
#import "CKBlurView.h"
#import "FBShimmeringView.h"
#import "IBKCarouselController.h"

@interface IBKHeaderView : UIView{
    UILabel *blocksLabel;
}

@property (nonatomic, strong) UIImageView *backmostWidget;
@property (nonatomic, strong) UIImageView *middleWidget;
@property (nonatomic, strong) UIImageView *foremostWidget;
@property (nonatomic, strong) CKBlurView *blur;
@property (nonatomic, strong) FBShimmeringView *shimmer;
@property (nonatomic, strong) IBKCarouselController *contr;
@property (nonatomic, strong) UIView *triangle;
@property (nonatomic, strong) UIView *bg;

-(void)beginAnimations;

@end
