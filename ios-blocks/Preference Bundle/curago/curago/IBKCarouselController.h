//
//  IBKCarouselController.h
//  curago
//
//  Created by Matt Clarke on 25/02/2015.
//
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface IBKCarouselController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *carousel;

@end
