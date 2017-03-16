//
//  IBKGameCenterTableCell.h
//  curago
//
//  Created by Matt Clarke on 10/02/2015.
//
//

#import <UIKit/UIKit.h>
#import <GameCenterFoundation/GKAchievementDescription.h>
#import "MarqueeLabel.h"

@interface IBKGameCenterTableCell : UITableViewCell

@property (nonatomic, strong) GKAchievementDescription *desc;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) MarqueeLabel *title;
@property (nonatomic, strong) UILabel *pointCount;

-(void)setupForDescriptionWithColor:(UIColor*)color;

@end
