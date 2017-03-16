#import <ControlCenterUI/CCUINightShiftSectionController.h>
#import <ControlCenterUI/CCUINightShiftContentView.h>

@interface CCUINightShiftSectionController : CCUIControlCenterSectionViewController
@property(nonatomic, retain) CCUINightShiftContentView *view;
-(void)viewWillAppear:(BOOL)arg1;
-(void)viewDidLoad;
@end