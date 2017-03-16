//
//  CVLaunchpadModalController.h
//  Convergance-Prefs
//
//  Created by Matt Clarke on 18/08/2014.
//
//

#import <UIKit/UIKit.h>
#import "curagoController.h"

@interface CVLaunchpadModalController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UIView *window;
    UIView *__view;
    UITableView *_table;
}

@property (nonatomic, weak) curagoController *delegate;
@property (nonatomic, strong) NSDictionary *articleTitlesPerSection;
@property (nonatomic, strong) NSDictionary *articleTitlesToBody;
@property (nonatomic, strong) NSArray *headerNames;

@end
