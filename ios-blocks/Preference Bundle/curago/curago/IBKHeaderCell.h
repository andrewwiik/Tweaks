//
//  IBKHeaderCell.h
//  curago
//
//  Created by Matt Clarke on 21/02/2015.
//
//

#import <Preferences/Preferences.h>
#import "CKBlurView.h"
#import "FBShimmeringView.h"

@interface IBKHeaderCell : PSTableCell {
    UILabel *blocksLabel;
}

@property (nonatomic, strong) UIImageView *backmostWidget;
@property (nonatomic, strong) UIImageView *middleWidget;
@property (nonatomic, strong) UIImageView *foremostWidget;
@property (nonatomic, strong) CKBlurView *blur;
@property (nonatomic, strong) FBShimmeringView *shimmer;

+(instancetype)sharedInstance;
-(void)viewDidLoad;

- (id)initWithSpecifier:(PSSpecifier *)specifier;

@end
