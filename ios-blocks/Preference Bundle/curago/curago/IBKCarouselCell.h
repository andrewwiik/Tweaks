//
//  IBKCarouselCell.h
//  curago
//
//  Created by Matt Clarke on 25/02/2015.
//
//

#import <Preferences/Preferences.h>
#import "IBKCarouselController.h"

@interface IBKCarouselCell : PSTableCell

@property (nonatomic, strong) IBKCarouselController *contr;

- (id)initWithSpecifier:(PSSpecifier *)specifier;

@end
