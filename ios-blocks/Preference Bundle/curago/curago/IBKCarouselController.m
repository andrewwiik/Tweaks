//
//  IBKCarouselController.m
//  curago
//
//  Created by Matt Clarke on 25/02/2015.
//
//

#import "IBKCarouselController.h"
#import "curagoController.h"

BOOL needsNewIndex = NO;

@interface IBKCarouselController ()

@end

@implementation IBKCarouselController 

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Create iCarousel
        
        [self loadView];
        
        _carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
        _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _carousel.type = iCarouselTypeRotary;
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.pagingEnabled = YES;
        
        //add carousel to view
        [self.view addSubview:_carousel];
    }
    return self;
}

- (CAGradientLayer*)gradientFrom:(UIColor*)from to:(UIColor*)to {
    UIColor *colorOne = from;
    UIColor *colorTwo = to;
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

-(void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    // return the total number of items in the carousel
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    // create new view if no view is available for recycling
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150.0f, 150.0f)];
        view.backgroundColor = [UIColor darkGrayColor];
        
        view.layer.cornerRadius = 12.5;
        view.layer.masksToBounds = YES;
        
        // Setup background, content, label and icon
        
        UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.tag = 0;
        
        bgView.layer.cornerRadius = 12.5;
        bgView.layer.masksToBounds = YES;
        
        [view addSubview:bgView];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 150-30-4.5, 25, 25)];
        icon.backgroundColor = [UIColor clearColor];
        icon.tag = 1;
        
        [view addSubview:icon];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 130, 106)];
        content.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        content.backgroundColor = [UIColor clearColor];
        content.textAlignment = NSTextAlignmentCenter;
        content.textColor = [UIColor whiteColor];
        content.tag = 2;
        content.numberOfLines = 0;
        
        [view addSubview:content];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(39, 150-37, 105, 30)];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        title.tag = 3;
        
        [view addSubview:title];
    }
    
    // Setup properties.
    
    UIColor *from;
    UIColor *to;
    NSString *title;
    NSString *content;
    UIImage *icon;
    
    NSString *suffix = @"";
    
    if ([UIScreen mainScreen].scale < 2.0) {
        suffix = @".png";
    } else if ([UIScreen mainScreen].scale >= 2.0 && [UIScreen mainScreen].scale < 3.0) {
        suffix = @"@2x.png";
    } else {
        suffix = @"@3x.png";
    }
    
    switch (index) {
        case 0:
            from = [UIColor colorWithRed:(126.0/255.0) green:(219.0/255.0) blue:(43.0/255.0) alpha:1.0];
            to = [UIColor colorWithRed:(59.0/255.0) green:(184.0/255.0) blue:(25.0/255.0) alpha:1.0];
            title = @"Manage widgets";
            content = @"Adjust the settings of widgets, and reassign widgets to different icons.";
            icon = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/PreferenceBundles/curago.bundle/SelectorIcons/Manage%@", suffix]];
            break;
        case 1:
            from = [UIColor colorWithRed:(241.0/255.0) green:(13.0/255.0) blue:(61.0/255.0) alpha:1.0];
            to = [UIColor colorWithRed:(241.0/255.0) green:(110.0/255.0) blue:(13.0/255.0) alpha:1.0];
            title = @"Advanced";
            content = @"Additional customisation settings to further refine iOS Blocks.";
            icon = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/PreferenceBundles/curago.bundle/SelectorIcons/Advanced%@", suffix]];
            break;
        case 2:
            from = [UIColor colorWithRed:(13.0/255.0) green:(115.0/255.0) blue:(241.0/255.0) alpha:1.0];
            to = [UIColor colorWithRed:(13.0/255.0) green:(179.0/255.0) blue:(241.0/255.0) alpha:1.0];
            title = @"FAQ / Support";
            content = @"Send feedback to the developers, or browse frequently asked questions.";
            icon = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/PreferenceBundles/curago.bundle/SelectorIcons/Support%@", suffix]];
            break;
        default:
            break;
    }
    
    UILabel *titl = (UILabel*)[view viewWithTag:3];
    titl.text = title;
    
    UILabel *cont = (UILabel*)[view viewWithTag:2];
    cont.text = content;
    
    UIImageView *ic = (UIImageView*)[view viewWithTag:1];
    ic.image = icon;
    
    UIView *bgView = [view viewWithTag:0];
    CAGradientLayer *bgLayer = [self gradientFrom:from to:to];
    bgLayer.frame = view.bounds;
    [bgView.layer insertSublayer:bgLayer atIndex:0];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionFadeMin:
            return -0.2;
        case iCarouselOptionFadeMax:
            return 0.2;
        case iCarouselOptionFadeRange:
            return 1.25;
        case iCarouselOptionArc:
            if ([UIScreen mainScreen].bounds.size.width < 375)
                return M_PI*1.25;
            else
                return M_PI;
        default:
            return value;
    }
}

-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    if (needsNewIndex) {
        [[curagoController sharedInstance] loadInPrefsForIndex:(int)carousel.currentItemIndex animated:YES];
        needsNewIndex = NO;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    needsNewIndex = YES;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    _carousel.delegate = nil;
	_carousel.dataSource = nil;
}

@end
