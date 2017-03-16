#import "CCUIButtonSectionController.h"
#import "CCUIButtonStackPagingView.h"

@interface CCUIQuickLaunchSectionController : CCUIButtonSectionController
+(Class)buttonControllerClass;
@property (nonatomic, retain) CCUIButtonStackPagingView *view;
-(id)settings;
-(void)viewWillAppear:(BOOL)arg1 ;
-(id)sectionIdentifier;
-(void)_presentButtonActionPlatterWithCompletion:(/*^block*/id)arg1 ;
-(void)_dismissButtonActionPlatterWithCompletion:(/*^block*/id)arg1 ;
@end
