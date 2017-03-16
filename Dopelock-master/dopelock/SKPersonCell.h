#import <Preferences/PSTableCell.h>
#include "Generic.h"

@interface SKPersonCell : PSTableCell {
    UIImageView *_background;
    UILabel *label;
    UILabel *label2;
    UIButton *twitterButton;
}

-(NSString*)personDescription;
-(NSString*)imageName;
-(NSString*)name;
-(NSString*)twitterHandle;

-(void)updateImage;
-(NSString*)localizedString:(NSString*)string;
@end