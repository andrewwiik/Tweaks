//
//  IBKNotificationsTableCell.h
//  curago
//
//  Created by Matt Clarke on 30/07/2014.
//
//

#import <UIKit/UIKit.h>
#import <BulletinBoard/BBBulletin.h>
#import "IBKLabel.h"

#define isIpadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface IBKNotificationsTableCell : UITableViewCell

@property (nonatomic, strong) NSTimer *dateTimer;
@property (nonatomic, strong) UIColor *superviewColouration;
@property (nonatomic, strong) IBKLabel *title;
@property (nonatomic, strong) IBKLabel *content;
@property (nonatomic, strong) IBKLabel *dateLabel;
@property (nonatomic, strong) UIImageView *attachment;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) BBBulletin *bulletin;
@property (nonatomic, strong) NSBundle *translations;

+(BOOL)isSuperviewColourationBright:(UIColor*)color;

-(void)initialiseForBulletin:(BBBulletin*)bulletin andRowWidth:(CGFloat)width;

@end
