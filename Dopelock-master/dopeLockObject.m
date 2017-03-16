#import "Headers.h"
#import "dopeLockObject.h"

@implementation DopeLock

-(void)updateTodayTomorrow:(NSMutableArray *)arg1 {
    self.todayNCText = [NSString stringWithFormat:@"%@\n%@\n%@", arg1[0], arg1[1], arg1[2]];
    self.todayAltNCText = [NSString stringWithFormat:@"%@\n%@", arg1[0], arg1[1]];
    self.tomorrowNCText = [NSString stringWithFormat:@"%@", arg1[4]];
}

-(void) randomGreeting {
    int smallest = 1;
    int largest = 21;
    int random = smallest + arc4random() % (largest + 1 - smallest);

    switch (random)
    {
    case 1: self.h2.text = @"Please check your events for today!"; break;
    case 2: self.h2.text = @"How are you today?"; break;
    case 3: self.h2.text = @"Have a nice day!"; break;
    case 4: self.h2.text = @"You look so young today!"; break;
    case 5: self.h2.text = @"Your smile brightens the room :)"; break;
    case 6: self.h2.text = @"Have you lost weight?"; break;
    case 7: self.h2.text = @"You look so young!"; break;
    case 8: self.h2.text = @"Check the weather for today!"; break;
    case 9: self.h2.text = @"You are a special person!"; break;
    case 10: self.h2.text = @"You are not a failure"; break;
    case 11: self.h2.text = @"It is a beautiful day!"; break;
    case 12: self.h2.text = @"Hope you have a perfect day today!"; break;
    case 13: self.h2.text = @"Good luck!"; break;
    case 14: self.h2.text = @"You are so beautiful :)"; break;
    case 15: self.h2.text = @"Every minute spent wih you is a minute well spent."; break;
    case 16: self.h2.text = @"I hope you're having a good day!"; break;
    case 17: self.h2.text = @"Be happy!"; break;
    case 18: self.h2.text = @"Today is a new day, with infinite possibilities."; break;
    case 19: self.h2.text = @"In a few hours, you can go back to sleep!"; break;
    case 20: self.h2.text = @"YOOUUUUUHHHHOOOUUUU!"; break;
    default: self.h2.text = @"You're awesome :)"; break;
    }
}

-(void)updateView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
        screenWidth = screenHeight;

    NSDate *date = [NSDate date];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"HH"];
    int hour = [[timeFormat stringFromDate:date] intValue];
    prevHour = hour;
    [timeFormat release];
    //Update events
    EKEventStore *store = [[EKEventStore alloc] init];
    NSPredicate *predicateToday = nil;
    NSArray *eventsToday = nil;
    _events0 = [[NSMutableArray alloc] init];
    _events1 = [[NSMutableArray alloc] init];
    _events2 = [[NSMutableArray alloc] init];
    _events3 = [[NSMutableArray alloc] init];
    _events4 = [[NSMutableArray alloc] init];
    _events5 = [[NSMutableArray alloc] init];
    _events6 = [[NSMutableArray alloc] init];
    UITableView *tableView = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 10, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    else
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 20, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    NSDate *dateIncrement = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSDate *startOfDay = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    NSDate *endOfDay = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];

    //Day 0 - Today
    tableView.tag = 1000;
    [self drawBackgroundForEvents:0 date:dateIncrement view:&_eventViewDay0];
    predicateToday = [store predicateForEventsWithStartDate:startOfDay endDate:endOfDay calendars:nil];
    eventsToday = [store eventsMatchingPredicate:predicateToday];
    [_events0 removeAllObjects];
    [_events0 addObjectsFromArray:eventsToday];
    [tableView reloadData];
    [self.eventViewDay0 addSubview: tableView];
    [self addSubview:self.eventViewDay0];

    //Day 1 - Tomorrow
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 10, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    else
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 20, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 1001;
    date = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
    dateIncrement = [calendar dateByAddingComponents:dayComponent toDate:dateIncrement options:0];
    startOfDay = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    endOfDay = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    predicateToday = [store predicateForEventsWithStartDate:startOfDay endDate:endOfDay calendars:nil];
    eventsToday = [store eventsMatchingPredicate:predicateToday];
    [_events1 removeAllObjects];
    [_events1 addObjectsFromArray:eventsToday];
    [self drawBackgroundForEvents:1 date:dateIncrement view:&_eventViewDay1];
    [tableView reloadData];
    [self.eventViewDay1 addSubview: tableView];
    [self addSubview:self.eventViewDay1];

    //Day 2
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 10, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    else
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 20, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 1002;
    date = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
    dateIncrement = [calendar dateByAddingComponents:dayComponent toDate:dateIncrement options:0];
    startOfDay = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    endOfDay = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    predicateToday = [store predicateForEventsWithStartDate:startOfDay endDate:endOfDay calendars:nil];
    eventsToday = [store eventsMatchingPredicate:predicateToday];
    [_events2 removeAllObjects];
    [_events2 addObjectsFromArray:eventsToday];
    [self drawBackgroundForEvents:2 date:dateIncrement view:&_eventViewDay2];
    [tableView reloadData];
    [self.eventViewDay2 addSubview: tableView];
    [self addSubview:self.eventViewDay2];

    //Day 3
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 10, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    else
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 20, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 1003;
    date = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
    dateIncrement = [calendar dateByAddingComponents:dayComponent toDate:dateIncrement options:0];
    startOfDay = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    endOfDay = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    predicateToday = [store predicateForEventsWithStartDate:startOfDay endDate:endOfDay calendars:nil];
    eventsToday = [store eventsMatchingPredicate:predicateToday];
    [_events3 removeAllObjects];
    [_events3 addObjectsFromArray:eventsToday];
    [self drawBackgroundForEvents:3 date:dateIncrement view:&_eventViewDay3];
    [tableView reloadData];
    [self.eventViewDay3 addSubview: tableView];
    [self addSubview:self.eventViewDay3];

    //Day 4
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 10, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    else
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 20, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 1004;
    date = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
    dateIncrement = [calendar dateByAddingComponents:dayComponent toDate:dateIncrement options:0];
    startOfDay = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    endOfDay = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    predicateToday = [store predicateForEventsWithStartDate:startOfDay endDate:endOfDay calendars:nil];
    eventsToday = [store eventsMatchingPredicate:predicateToday];
    [_events4 removeAllObjects];
    [_events4 addObjectsFromArray:eventsToday];
    [self drawBackgroundForEvents:4 date:dateIncrement view:&_eventViewDay4];
    [tableView reloadData];
    [self.eventViewDay4 addSubview: tableView];
    [self addSubview:self.eventViewDay4];

    //Day 5
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 10, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    else
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 20, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 1005;
    date = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
    dateIncrement = [calendar dateByAddingComponents:dayComponent toDate:dateIncrement options:0];
    startOfDay = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    endOfDay = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    predicateToday = [store predicateForEventsWithStartDate:startOfDay endDate:endOfDay calendars:nil];
    eventsToday = [store eventsMatchingPredicate:predicateToday];
    [_events5 removeAllObjects];
    [_events5 addObjectsFromArray:eventsToday];
    [self drawBackgroundForEvents:5 date:dateIncrement view:&_eventViewDay5];
    [tableView reloadData];
    [self.eventViewDay5 addSubview: tableView];
    [self addSubview:self.eventViewDay5];

    //Day 6 - Last day
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 10, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    else
        tableView = [[UITableView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 20, 10, screenWidth * 0.6, 55) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.tag = 1006;
    date = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
    dateIncrement = [calendar dateByAddingComponents:dayComponent toDate:dateIncrement options:0];
    startOfDay = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    endOfDay = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    predicateToday = [store predicateForEventsWithStartDate:startOfDay endDate:endOfDay calendars:nil];
    eventsToday = [store eventsMatchingPredicate:predicateToday];
    [_events6 removeAllObjects];
    [_events6 addObjectsFromArray:eventsToday];
    [self drawBackgroundForEvents:6 date:dateIncrement view:&_eventViewDay6];
    [tableView reloadData];
    [self.eventViewDay6 addSubview: tableView];
    [self addSubview:self.eventViewDay6];

    [dayComponent release];

    NSString *timeOfDay = @"";
    if (hour < 11)
        timeOfDay = @"Morning";
    else if (hour < 17)
        timeOfDay = @"Afternoon";
    else
        timeOfDay = @"Evening";

    if (self.h1 != nil) {
        [self.h1 removeFromSuperview];
    }
    self.h1.text = [NSString stringWithFormat:@"Good %@ %@!", timeOfDay, _user];
     if (hour > 8 && hour < 20) {
        self.h1.textColor = [UIColor blackColor];
    } else {
        self.h1.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
    }
    if (self.h2 != nil) {
        [self.h2 removeFromSuperview];
    }
    [self randomGreeting];
    if (hour > 8 && hour < 20) {
        self.h2.textColor = [UIColor blackColor];
    } else {
        self.h2.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
    }
    if (self.ncToday != nil) {
        [self.ncToday removeFromSuperview];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.ncToday.frame =  CGRectMake(20, 260, screenWidth - 30, 250);
    else
        self.ncToday.frame = CGRectMake(5, 130, screenWidth - 30, 250);
    //If event at least one event exists then display this text
    self.ncToday.text = self.todayNCText;
    //Else display this text
    //self.ncToday.text = self.todayAltNCText;
    if (hour > 8 && hour < 20) {
        self.ncToday.textColor = [UIColor blackColor];
    } else {
        self.ncToday.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.ncToday.font = [self.ncToday.font fontWithSize:21];
    else
        self.ncToday.font = [self.ncToday.font fontWithSize:12];
    self.ncToday.lineBreakMode = UILineBreakModeWordWrap;
    self.ncToday.numberOfLines = 0;
    [self.ncToday sizeToFit];


    if (self.ncTomorrow != nil) {
        [self.ncTomorrow removeFromSuperview];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.ncTomorrow.frame = CGRectMake(20, 425, screenWidth - 30, 250);
    else
        self.ncTomorrow.frame = CGRectMake(5, 245, screenWidth - 30, 250);
    self.ncTomorrow.text = self.tomorrowNCText;
    if (hour > 8 && hour < 20) {
        self.ncTomorrow.textColor = [UIColor blackColor];
    } else {
        self.ncTomorrow.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.ncTomorrow.font = [self.ncTomorrow.font fontWithSize:21];
    else
        self.ncTomorrow.font = [self.ncTomorrow.font fontWithSize:12];
    self.ncTomorrow.lineBreakMode = UILineBreakModeWordWrap;
    self.ncTomorrow.numberOfLines = 0;
    [self.ncTomorrow sizeToFit];

    if (self.topView != nil) {
        [self.topView removeFromSuperview];
        [self.blurEffectView1 removeFromSuperview];
    }
    if (hour > 8 && hour < 20) {
        self.effect1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    } else {
        self.effect1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    self.blurEffectView1 = [[UIVisualEffectView alloc] initWithEffect:self.effect1];
    [self.blurEffectView1 setFrame:self.topView.bounds];
    [self.topView addSubview:self.blurEffectView1];

    if(self.todayTomorrow != nil)
        [self.todayTomorrow removeFromSuperview];
    if(self.todayDate != nil)
        [self.todayDate removeFromSuperview];
    if(self.calendarLabel != nil)
        [self.calendarLabel removeFromSuperview];
    if(self.textColor){
        self.todayTomorrow.textColor = [UIColor whiteColor];
        self.todayDate.textColor = [UIColor whiteColor];
        self.calendarLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.todayTomorrow.textColor = [UIColor blackColor];
        self.todayDate.textColor = [UIColor blackColor];
        self.calendarLabel.textColor = [UIColor blackColor];
    }

    if (self.todayTomorrowView != nil)
    {
        [self.todayTomorrowView removeFromSuperview];
        [self.blurEffectView2 removeFromSuperview];
    }
    if (hour > 8 && hour < 20) {
        self.effect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    } else {
        self.effect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    self.blurEffectView2 = [[UIVisualEffectView alloc] initWithEffect:self.effect2];
    [self.blurEffectView2 setFrame:self.todayTomorrowView.bounds];
    [self.todayTomorrowView addSubview:self.blurEffectView2];

    [self addSubview:self.topView];
    [self addSubview:self.h1];
    [self addSubview:self.h2];
    [self addSubview:self.todayTomorrowView];
    [self addSubview:self.todayTomorrow];
    [self addSubview:self.todayDate];
    [self addSubview:self.calendarLabel];
    [self addSubview:self.ncToday];
    [self addSubview:self.ncTomorrow];


    //[store release];

    NSLog(@"DopeLock log: Events updated");
}

-(void)addBasicsToView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
        screenWidth = screenHeight;
    // Getting the date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"EEEE, MMMM dd, yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    [dateFormat release];

    //Getting the hour
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"HH"];
    int hour = [[timeFormat stringFromDate:date] intValue];
    prevHour = hour;
    [timeFormat release];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.ncToday = [[UILabel alloc] initWithFrame:CGRectMake(20, 260, screenWidth - 30, 250)];
    else
        self.ncToday = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, screenWidth - 30, 250)];
    self.ncToday.text = self.todayNCText;
    if (hour > 8 && hour < 20) {
        self.ncToday.textColor = [UIColor blackColor];
    } else {
        self.ncToday.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.ncToday.font = [self.ncToday.font fontWithSize:21];
    else
        self.ncToday.font = [self.ncToday.font fontWithSize:12];
    self.ncToday.lineBreakMode = UILineBreakModeWordWrap;
    self.ncToday.numberOfLines = 0;
    [self.ncToday sizeToFit];
    [self addSubview:self.ncToday];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.ncTomorrow = [[UILabel alloc] initWithFrame:CGRectMake(20, 425, screenWidth - 30, 250)];
    else
        self.ncTomorrow = [[UILabel alloc] initWithFrame:CGRectMake(5, 245, screenWidth - 30, 250)];
    self.ncTomorrow.text = self.tomorrowNCText;
    if (hour > 8 && hour < 20) {
        self.ncTomorrow.textColor = [UIColor blackColor];
    } else {
        self.ncTomorrow.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.ncTomorrow.font = [self.ncTomorrow.font fontWithSize:21];
    else
        self.ncTomorrow.font = [self.ncTomorrow.font fontWithSize:12];
    self.ncTomorrow.lineBreakMode = UILineBreakModeWordWrap;
    self.ncTomorrow.numberOfLines = 0;
    [self.ncTomorrow sizeToFit];
    [self addSubview:self.ncTomorrow];

    NSString *timeOfDay = @"";
    if (hour < 11)
        timeOfDay = @"Morning";
    else if (hour < 17)
        timeOfDay = @"Afternoon";
    else
        timeOfDay = @"Evening";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.h1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, screenWidth, 60)];
    else
        self.h1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, screenWidth, 37)];
    self.h1.backgroundColor = [UIColor clearColor];
    self.h1.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    if (hour > 8 && hour < 20) {
        self.h1.textColor = [UIColor blackColor];
    } else {
        self.h1.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
    }
    self.h1.text = [NSString stringWithFormat:@"Good %@ %@!", timeOfDay, _user];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.h1.font = [self.h1.font fontWithSize:55];
    else
        self.h1.font = [self.h1.font fontWithSize:32];
    [self addSubview:self.h1];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.h2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, screenWidth, 50)];
    else
        self.h2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, screenWidth, 32)];

    self.h2.backgroundColor = [UIColor clearColor];
    self.h2.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    if (hour > 8 && hour < 20) {
        self.h2.textColor = [UIColor blackColor];
    } else {
        self.h2.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
    }
    [self randomGreeting];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.h2.font = [self.h2.font fontWithSize:25];
    else
        self.h2.font = [self.h2.font fontWithSize:16];

    [self addSubview:self.h2];

    // "Good..." + "Please..." view (at the top) + blur
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight / 8)];
    self.topView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.01];
    if (hour > 8 && hour < 20) {
        self.effect1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    } else {
        self.effect1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    self.blurEffectView1 = [[UIVisualEffectView alloc] initWithEffect:self.effect1];
    [self.blurEffectView1 setFrame:self.topView.bounds];
    [self.topView addSubview:self.blurEffectView1];

    // Today & tomorrow label
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.todayTomorrow = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 250, 50)];
    else
        self.todayTomorrow = [[UILabel alloc] initWithFrame:CGRectMake(5, 85, 150, 50)];
    self.todayTomorrow.backgroundColor = [UIColor clearColor];
    self.todayTomorrow.textAlignment = UITextAlignmentLeft; // UITextAlignmentCenter, UITextAlignmentLeft
    self.todayTomorrow.textColor = [UIColor blackColor];
    self.todayTomorrow.text = @"Today & Tomorrow";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.todayTomorrow.font = [self.todayTomorrow.font fontWithSize:25];
    else
        self.todayTomorrow.font = [self.todayTomorrow.font fontWithSize:14];

    // Label for the date
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.todayDate = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 400, 200, 380, 50)];
    else
        self.todayDate = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 255, 85, 250, 50)];
    self.todayDate.backgroundColor = [UIColor clearColor];
    self.todayDate.textAlignment = UITextAlignmentRight; // UITextAlignmentCenter, UITextAlignmentLeft
    self.todayDate.textColor = [UIColor blackColor];
    self.todayDate.text = dateString;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.todayDate.font = [self.todayDate.font fontWithSize:25];
    else
        self.todayDate.font = [self.todayDate.font fontWithSize:14];

    // View for the today & tomorrow text + blur
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.todayTomorrowView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, screenWidth, 250)];
    else
        self.todayTomorrowView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, screenWidth, 175)];
    self.todayTomorrowView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.01];
    if (hour > 8 && hour < 20) {
        self.effect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    } else {
        self.effect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    self.blurEffectView2 = [[UIVisualEffectView alloc] initWithEffect:self.effect2];
    [self.blurEffectView2 setFrame:self.todayTomorrowView.bounds];
    [self.todayTomorrowView addSubview:self.blurEffectView2];

    // Calendar label
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 535, 250, 50)];
    else
        self.calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 300, 250, 50)];
    self.calendarLabel.backgroundColor = [UIColor clearColor];
    self.calendarLabel.textColor = [UIColor blackColor];
    self.calendarLabel.text = @"Calendar";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.calendarLabel.font = [self.calendarLabel.font fontWithSize:25];
    else
        self.calendarLabel.font = [self.calendarLabel.font fontWithSize:14];

    // Wizage, you need to adapt this for iPhone
    // Tomorrow label
    /*UILabel *tomorrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 250, 50)];
    tomorrowLabel.backgroundColor = [UIColor clearColor];
    tomorrowLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    tomorrowLabel.textColor=[UIColor blackColor];
    tomorrowLabel.text = labelText;*/

    // This beautiful line :)
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.separator = [[UIView alloc] initWithFrame:CGRectMake(0, 400, screenWidth, 1)];
    else
        self.separator = [[UIView alloc] initWithFrame:CGRectMake(0, 240, screenWidth, 1)];
    self.separator.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];

    // Display views + labels
    [self addSubview:self.topView];
    [self addSubview:self.h1];
    [self addSubview:self.h2];
    [self addSubview:self.todayTomorrow];
    [self addSubview:self.todayDate];
    [self addSubview:self.todayTomorrowView];
    [self addSubview:self.calendarLabel];
    [self addSubview:self.separator];

    //[eventScrollView addSubview:tomorrowLabel];
}

/*
* Rotates the view
*/
-(void) rotateView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
        screenWidth = screenHeight;
    /*
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"EEEE, MMMM dd, yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    [dateFormat release];
    //Getting the hour
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"HH"];
    int hour = [[timeFormat stringFromDate:date] intValue];
    prevHour = hour;
    [timeFormat release];
    */
    // "Good..." + "Please..." view (at the top) + blur
    if (self.topView != nil) {
        [self.topView removeFromSuperview];
        [self.blurEffectView1 removeFromSuperview];
    }
    self.topView.frame = CGRectMake(0, 0, screenWidth, screenHeight / 9);

    //self.topView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.01];
    [self.blurEffectView1 setFrame:self.topView.bounds];
    [self.topView addSubview:self.blurEffectView1];

    if (self.h1 != nil)
    {
        [self.h1 removeFromSuperview];
    }
    self.h1.frame = CGRectMake(0, 5, screenWidth, 60);
    if (self.h2 != nil)
    {
        [self.h2 removeFromSuperview];
    }
    self.h2.frame = CGRectMake(0, 90, screenWidth, 60);

    // "Good morning" label
    /*
    NSString *timeOfDay = @"";
    if(hour < 11)
        timeOfDay = @"Morning";
    else if (hour < 17)
        timeOfDay = @"Afternoon";
    else
        timeOfDay = @"Evening";
    self.h1.frame = CGRectMake(0, 5, screenWidth, 60);
    self.h1.backgroundColor = [UIColor clearColor];
    self.h1.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    self.h1.textColor=[UIColor blackColor];
    self.h1.text = [NSString stringWithFormat:@"Good %@ %@!", timeOfDay, user];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.h1.font = [self.h1.font fontWithSize:55];
    else
        self.h1.font = [self.h1.font fontWithSize:25];
    // "Please check..." label
    self.h2.frame = CGRectMake(0, 90, screenWidth, 60);
    self.h2.backgroundColor = [UIColor clearColor];
    self.h2.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    self.h2.textColor=[UIColor blackColor];
    self.h2.text = @"Please check your events for today";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.h2.font = [self.h2.font fontWithSize:25];
    else
        self.h2.font = [self.h2.font fontWithSize:16];
    */
    // Today & tomorrow label
    if (self.todayTomorrow != nil) {
        [self.todayTomorrow removeFromSuperview];
    }
    self.todayTomorrow.frame = CGRectMake(0, 200, 250, 50);
    /*
    self.todayTomorrow.backgroundColor = [UIColor clearColor];
    self.todayTomorrow.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    self.todayTomorrow.textColor=[UIColor blackColor];
    self.todayTomorrow.text = @"Today & Tomorrow";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.todayTomorrow.font = [self.todayTomorrow.font fontWithSize:25];
    else
        self.todayTomorrow.font = [self.todayTomorrow.font fontWithSize:16];
        */
    // Label for the date
    if (self.todayDate != nil) {
        [self.todayDate removeFromSuperview];
    }
    self.todayDate.frame = CGRectMake(screenWidth - 350, 200, 350, 50);
    /*
    self.todayDate.backgroundColor = [UIColor clearColor];
    self.todayDate.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    self.todayDate.textColor=[UIColor blackColor];
    self.todayDate.text = dateString;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.todayDate.font = [self.todayDate.font fontWithSize:25];
    else
        self.todayDate.font = [self.todayDate.font fontWithSize:16];
        */

    // View for the today & tomorrow text + blur
    if (self.todayTomorrowView != nil) {
        [self.todayTomorrowView removeFromSuperview];
        [self.blurEffectView2 removeFromSuperview];
    }
    self.todayTomorrowView.frame = CGRectMake(0, 250, screenWidth, 250);
    [self.blurEffectView2 setFrame:self.todayTomorrowView.bounds];
    [self.todayTomorrowView addSubview:self.blurEffectView2];
    /*
    self.todayTomorrowView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.01];
    UIBlurEffect *effect2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView2 = [[UIVisualEffectView alloc] initWithEffect:effect2];
    [blurEffectView2 setFrame:self.todayTomorrowView.bounds];
    [self.todayTomorrowView addSubview:blurEffectView2];
    */

    // Calendar label
    if (self.calendarLabel != nil) {
        [self.calendarLabel removeFromSuperview];
    }
    self.calendarLabel.frame = CGRectMake(20, 535, 250, 50);
    /*
    self.calendarLabel.backgroundColor = [UIColor clearColor];
    self.calendarLabel.textColor=[UIColor blackColor];
    self.calendarLabel.text = @"Calendar";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.calendarLabel.font = [self.calendarLabel.font fontWithSize:25];
    else
        self.calendarLabel.font = [self.calendarLabel.font fontWithSize:16];
    if (self.ncToday != nil) {
        [self.ncToday removeFromSuperview];
    }
    self.ncToday.frame = CGRectMake(20,275,screenWidth-30, 250);
    self.ncToday.text = todayText;
    self.ncToday.textColor = [UIColor blackColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.ncToday.font = [self.ncToday.font fontWithSize:21];
    else
        self.ncToday.font = [self.ncToday.font fontWithSize:12];
    self.ncToday.lineBreakMode = UILineBreakModeWordWrap;
    self.ncToday.numberOfLines = 0;
    [self.ncToday sizeToFit];
    */


    // Wizage, you need to adapt this for iPhone
    // Tomorrow label
    /*UILabel *tomorrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 250, 50)];
    tomorrowLabel.backgroundColor = [UIColor clearColor];
    tomorrowLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    tomorrowLabel.textColor=[UIColor blackColor];
    tomorrowLabel.text = labelText;*/

    // This beautiful line :)
    if (self.separator != nil) {
        [self.separator removeFromSuperview];
    }
    self.separator.frame = CGRectMake(0, 400, screenWidth, 1);
    /*
    self.separator.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    */

    if (self.ncToday != nil) {
        [self.ncToday removeFromSuperview];
    }
    self.ncToday.frame = CGRectMake(20, 275, screenWidth - 30, 250);

    if (self.ncTomorrow != nil) {
        [self.ncTomorrow removeFromSuperview];
    }
    self.ncTomorrow.frame = CGRectMake(20, 425, screenWidth - 30, 250);

    // Display views + labels

    [self addSubview:self.topView];
    [self addSubview:self.h1];
    [self addSubview:self.h2];
    [self addSubview:self.todayTomorrow];
    [self addSubview:self.todayDate];
    [self addSubview:self.todayTomorrowView];
    [self addSubview:self.calendarLabel];
    [self addSubview:self.separator];
    [self addSubview:self.ncToday];
    [self addSubview:self.ncTomorrow];

    /*
    [self.topView setNeedsDisplay];
    [self.todayTomorrow setNeedsDisplay];
    [self.todayDate setNeedsDisplay];
    [self.todayTomorrowView setNeedsDisplay];
    [self.calendarLabel setNeedsDisplay];
    [self.separator setNeedsDisplay];
    [self.ncToday setNeedsDisplay];
    [self updateView];
    */
}

/*
*   This will draw a block for each day and nothing more. We will have a cool scroll view to go through all the events of the day.
*/
-(void)drawBackgroundForEvents:(int)dayNumber date:(NSDate *)dateToDraw view:(UIView **)eventView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
        screenWidth = screenHeight;

    NSDate *date = [NSDate date];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"HH"];
    int hour = [[timeFormat stringFromDate:date] intValue];
    prevHour = hour;
    [timeFormat release];
    if (*eventView != nil)
    {
        [*eventView removeFromSuperview];
        [*eventView release];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        *eventView = [[UIView alloc] initWithFrame:CGRectMake(0, 580 + (170 * dayNumber) , screenWidth, 150)];
    else
        *eventView = [[UIView alloc] initWithFrame:CGRectMake(0, 340 + (170 * dayNumber) , screenWidth, 150)];
    [*eventView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.01]];
    if (hour > 8 && hour < 20) {
        self.effect3 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    } else {
        self.effect3 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    UIVisualEffectView *blurEffectView3 = [[UIVisualEffectView alloc] initWithEffect:self.effect3];
    [blurEffectView3 setFrame:[*eventView bounds]];
    [*eventView addSubview:blurEffectView3];


    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 5 , 70, 90)];

    redView.backgroundColor = [UIColor colorWithRed:240.0f / 255.0f green:101.0f / 255.0f blue:134.0f / 255.0f alpha:1.0f];

    NSDateFormatter *eventDay = [[NSDateFormatter alloc]init];
    [eventDay setDateFormat:@"EEEE"];
    NSString *eventDayString = [eventDay stringFromDate:dateToDraw];
    [eventDay release];

    NSDateFormatter *eventNumber = [[NSDateFormatter alloc]init];
    [eventNumber setDateFormat:@"dd"];
    NSString *eventNumberString = [eventNumber stringFromDate:dateToDraw];
    [eventNumber release];

    NSDateFormatter *eventMonth = [[NSDateFormatter alloc]init];
    [eventMonth setDateFormat:@"MMMM"];
    NSString *eventMonthString = [eventMonth stringFromDate:dateToDraw];
    [eventMonth release];

    UILabel *eventDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3 , 70, 20)];
    eventDayLabel.backgroundColor = [UIColor clearColor];
    eventDayLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    eventDayLabel.textColor = [UIColor whiteColor];
    eventDayLabel.text = eventDayString;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        eventDayLabel.font = [eventDayLabel.font fontWithSize:8];
    else
        eventDayLabel.font = [eventDayLabel.font fontWithSize:8];


    UILabel *eventNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 , 70, 50)];
    eventNumberLabel.backgroundColor = [UIColor clearColor];
    eventNumberLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    eventNumberLabel.textColor = [UIColor whiteColor];
    eventNumberLabel.text = eventNumberString;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        eventNumberLabel.font = [eventNumberLabel.font fontWithSize:32];
    else
        eventNumberLabel.font = [eventNumberLabel.font fontWithSize:26];


    UILabel *eventMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 70, 50)];
    eventMonthLabel.backgroundColor = [UIColor clearColor];
    eventMonthLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    eventMonthLabel.textColor = [UIColor whiteColor];
    eventMonthLabel.text = eventMonthString;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        eventMonthLabel.font = [eventMonthLabel.font fontWithSize:9];
    else
        eventMonthLabel.font = [eventMonthLabel.font fontWithSize:9];

    UIView *eventLine = [[UIView alloc] initWithFrame:CGRectMake(5, 65 , 60, 1)];
    eventLine.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];

    UIView *descriptionLine = [[UIView alloc] initWithFrame:CGRectMake(100, 95, screenWidth - 120, 1)];
    descriptionLine.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];


    [redView addSubview:eventDayLabel];
    [redView addSubview:eventNumberLabel];
    [redView addSubview:eventMonthLabel];
    [redView addSubview:eventLine];
    [*eventView addSubview:redView];
    [*eventView addSubview:descriptionLine];
    [*eventView addSubview:[self drawGridView]];
}


-(UIView *)drawGridView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
        screenWidth = screenHeight;

    UIView *grid = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        grid = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , screenWidth, 150)];
    else
        grid = [[UIView alloc] initWithFrame:CGRectMake(10, 0, screenWidth, 150)];
    UIView *grid1 = [[UIView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 10, 10, (screenWidth * 0.6), 1)];
    grid1.backgroundColor = [UIColor whiteColor];
    UIView *grid2 = [[UIView alloc] initWithFrame:CGRectMake((screenWidth * 0.25) + 10, 65 , (screenWidth * 0.6), 1)];
    grid2.backgroundColor = [UIColor whiteColor];
    float beforeGrid = (screenWidth * 0.25) + 10;
    float gridWidth = screenWidth * 0.6;
    float oneHour = gridWidth / 24;
    UIView *grid3 = [[UIView alloc] initWithFrame:CGRectMake(beforeGrid + oneHour * 6, 10 , 1, 55)];
    grid3.backgroundColor = [UIColor whiteColor];
    UIView *grid4 = [[UIView alloc] initWithFrame:CGRectMake(beforeGrid + oneHour * 12, 10 , 1, 55)];
    grid4.backgroundColor = [UIColor whiteColor];
    UIView *grid5 = [[UIView alloc] initWithFrame:CGRectMake(beforeGrid + oneHour * 18, 10 , 1, 55)];
    grid5.backgroundColor = [UIColor whiteColor];
    UILabel *grid6am = [[UILabel alloc] initWithFrame:CGRectMake((beforeGrid + oneHour * 6) - 25, 70 , 50, 10)];
    grid6am.backgroundColor = [UIColor clearColor];
    grid6am.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    grid6am.textColor = [UIColor whiteColor];
    grid6am.text = @"6am";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        grid6am.font = [grid6am.font fontWithSize:8];
    else
        grid6am.font = [grid6am.font fontWithSize:8];
    UILabel *grid12pm = [[UILabel alloc] initWithFrame:CGRectMake((beforeGrid + oneHour * 12) - 25, 70 , 50, 10)];
    grid12pm.backgroundColor = [UIColor clearColor];
    grid12pm.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    grid12pm.textColor = [UIColor whiteColor];
    grid12pm.text = @"12pm";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        grid12pm.font = [grid12pm.font fontWithSize:8];
    else
        grid12pm.font = [grid12pm.font fontWithSize:8];
    UILabel *grid6pm = [[UILabel alloc] initWithFrame:CGRectMake((beforeGrid + oneHour * 18) - 25, 70 , 50, 10)];
    grid6pm.backgroundColor = [UIColor clearColor];
    grid6pm.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    grid6pm.textColor = [UIColor whiteColor];
    grid6pm.text = @"6pm";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        grid6pm.font = [grid6pm.font fontWithSize:8];
    else
        grid6pm.font = [grid6pm.font fontWithSize:8];
    [grid addSubview:grid1];
    [grid addSubview:grid2];
    [grid addSubview:grid3];
    [grid addSubview:grid4];
    [grid addSubview:grid5];
    [grid addSubview:grid6am];
    [grid addSubview:grid12pm];
    [grid addSubview:grid6pm];
    return grid;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    if (tableView.tag == 1000)
        return [_events0 count];
    else if (tableView.tag == 1001)
        return [_events1 count];
    else if (tableView.tag == 1002)
        return [_events2 count];
    else if (tableView.tag == 1003)
        return [_events3 count];
    else if (tableView.tag == 1004)
        return [_events4 count];
    else if (tableView.tag == 1005)
        return [_events5 count];
    else if (tableView.tag == 1006)
        return [_events6 count];
    else
        return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 12;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentSelectedIndexPath = [tableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        [[tableView cellForRowAtIndexPath:currentSelectedIndexPath] setBackgroundColor:[UIColor clearColor]];
    }

    return indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *test = [[NSMutableArray alloc] init];
    if (tableView.tag == 1000)
        [test addObjectsFromArray:_events0];
    else if (tableView.tag == 1001)
        [test addObjectsFromArray:_events1];
    else if (tableView.tag == 1002)
        [test addObjectsFromArray:_events2];
    else if (tableView.tag == 1003)
        [test addObjectsFromArray:_events3];
    else if (tableView.tag == 1004)
        [test addObjectsFromArray:_events4];
    else if (tableView.tag == 1005)
        [test addObjectsFromArray:_events5];
    else if (tableView.tag == 1006)
        [test addObjectsFromArray:_events6];
    else
        return nil;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
        screenWidth = screenHeight;
    float gridWidth = screenWidth * 0.6;
    float oneHour = gridWidth / 24;
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    EKEvent *event = [test objectAtIndex:indexPath.row];
    NSDateFormatter *startHourEvent = [[NSDateFormatter alloc]init];
    [startHourEvent setDateFormat:@"HH"];
    NSString *startEventHourString = [startHourEvent stringFromDate:event.startDate];
    [startHourEvent release];
    int startEventHourInt = [startEventHourString intValue];
    NSDateFormatter *startMinuteEvent = [[NSDateFormatter alloc]init];
    [startMinuteEvent setDateFormat:@"mm"];
    NSString *startEventMinuteString = [startMinuteEvent stringFromDate:event.startDate];
    [startMinuteEvent release];
    int startEventMinuteInt = [startEventMinuteString intValue];
    NSDateFormatter *endHourEvent = [[NSDateFormatter alloc]init];
    [endHourEvent setDateFormat:@"HH"];
    NSString *endEventHourString = [endHourEvent stringFromDate:event.endDate];
    [endHourEvent release];
    int endEventHourInt = [endEventHourString intValue];
    NSDateFormatter *endMinuteEvent = [[NSDateFormatter alloc]init];
    [endMinuteEvent setDateFormat:@"mm"];
    NSString *endEventMinuteString = [endMinuteEvent stringFromDate:event.endDate];
    [endMinuteEvent release];
    int endEventMinuteInt = [endEventMinuteString intValue];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"dd"];
    int startDate = [[formater stringFromDate:event.startDate] intValue];
    int endDate = [[formater stringFromDate:event.endDate] intValue];
    [formater release];
    int hourDuration = 0;
    int minuteDuration = 0;
    if (startDate < endDate){//Needs work
        hourDuration = 24 - startEventHourInt;
        minuteDuration = 59 - startEventMinuteInt;
    }
    else
    {
        hourDuration = endEventHourInt - startEventHourInt;
        minuteDuration = endEventMinuteInt - startEventMinuteInt;

    }
    float oneMinute = oneHour / 60;
    UIView *eventBlockView = [[UIView alloc] initWithFrame:CGRectMake((oneHour * startEventHourInt) + (oneMinute * startEventMinuteInt), 0, oneHour * hourDuration + oneMinute * minuteDuration, 12)];
    eventBlockView.backgroundColor = [UIColor colorWithRed:106.0f / 255.0f green:139.0f / 255.0f blue:146.0f / 255.0f alpha:1.0f];
    UILabel *eventBlockName = [[UILabel alloc] initWithFrame:CGRectMake((oneHour * startEventHourInt) + (oneMinute * startEventMinuteInt), 0, oneHour * hourDuration + oneMinute * minuteDuration, 12)];
    eventBlockName.backgroundColor = [UIColor clearColor];
    eventBlockName.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    eventBlockName.textColor = [UIColor whiteColor];
    eventBlockName.text = event.title;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        eventBlockName.font = [eventBlockName.font fontWithSize:8];
    else
        eventBlockName.font = [eventBlockName.font fontWithSize:8];
    [cell addSubview:eventBlockView];
    [cell addSubview:eventBlockName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.3]];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
        screenWidth = screenHeight;
    NSDate *date = [NSDate date];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"HH"];
    int hour = [[timeFormat stringFromDate:date] intValue];
    [timeFormat release];
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth-80, 150)];
    if (tableView.tag == 1000) {
        EKEvent *event = [_events0 objectAtIndex:indexPath.row];
        NSDateFormatter *startDateEvent = [[NSDateFormatter alloc]init];
        [startDateEvent setDateFormat:@"HH:mm"];
        NSString *startEventDateString = [startDateEvent stringFromDate:event.startDate];
        [startDateEvent release];
        NSDateFormatter *endDateEvent = [[NSDateFormatter alloc]init];
        [endDateEvent setDateFormat:@"HH:mm"];
        NSString *endEventDateString = [endDateEvent stringFromDate:event.endDate];
        [endDateEvent release];
        if (self.eventDescription0 != nil)
        {
            [self.eventDescription0 removeFromSuperview];
        }
        self.eventDescription0 = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 96, screenWidth - 80, 49)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
        if (hour > 8 && hour < 20) {
            descriptionLabel.textColor = [UIColor blackColor];
        } else {
            descriptionLabel.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
        } if (event.notes != nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@. It starts at %@ and it ends at %@.\nNotes: %@", event.title, startEventDateString, endEventDateString, event.notes];
        } else if (event.notes == nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@.\nIt starts at %@ and it ends at %@.", event.title, startEventDateString, endEventDateString];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            descriptionLabel.font = [descriptionLabel.font fontWithSize:18];
        else
            descriptionLabel.font = [descriptionLabel.font fontWithSize:12];
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        CGRect myFrame = descriptionLabel.frame;
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, screenWidth - 80, myFrame.size.height);
        descriptionLabel.frame = myFrame;
        [self.eventDescription0 setContentSize:CGSizeMake(descriptionLabel.frame.size.width, descriptionLabel.frame.size.height)];
        [self.eventDescription0 addSubview:descriptionLabel];
        [_eventViewDay0 addSubview:self.eventDescription0];
    }
    else if (tableView.tag == 1001) {
        EKEvent *event = [_events1 objectAtIndex:indexPath.row];
        NSDateFormatter *startDateEvent = [[NSDateFormatter alloc]init];
        [startDateEvent setDateFormat:@"HH:mm"];
        NSString *startEventDateString = [startDateEvent stringFromDate:event.startDate];
        [startDateEvent release];
        NSDateFormatter *endDateEvent = [[NSDateFormatter alloc]init];
        [endDateEvent setDateFormat:@"HH:mm"];
        NSString *endEventDateString = [endDateEvent stringFromDate:event.endDate];
        [endDateEvent release];
        if (self.eventDescription1 != nil)
        {
            [self.eventDescription1 removeFromSuperview];
        }
        self.eventDescription1 = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 96, screenWidth - 80, 49)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
        if (hour > 8 && hour < 20) {
            descriptionLabel.textColor = [UIColor blackColor];
        } else {
            descriptionLabel.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
        } if (event.notes != nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@. It starts at %@ and it ends at %@.\nNotes: %@", event.title, startEventDateString, endEventDateString, event.notes];
        } else if (event.notes == nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@.\nIt starts at %@ and it ends at %@.", event.title, startEventDateString, endEventDateString];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            descriptionLabel.font = [descriptionLabel.font fontWithSize:18];
        else
            descriptionLabel.font = [descriptionLabel.font fontWithSize:12];
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        CGRect myFrame = descriptionLabel.frame;
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, screenWidth - 80, myFrame.size.height);
        descriptionLabel.frame = myFrame;
        [self.eventDescription1 setContentSize:CGSizeMake(descriptionLabel.frame.size.width, descriptionLabel.frame.size.height)];
        [self.eventDescription1 addSubview:descriptionLabel];
        [_eventViewDay1 addSubview:self.eventDescription1];
    }
    else if (tableView.tag == 1002) {
        EKEvent *event = [_events2 objectAtIndex:indexPath.row];
        NSDateFormatter *startDateEvent = [[NSDateFormatter alloc]init];
        [startDateEvent setDateFormat:@"HH:mm"];
        NSString *startEventDateString = [startDateEvent stringFromDate:event.startDate];
        [startDateEvent release];
        NSDateFormatter *endDateEvent = [[NSDateFormatter alloc]init];
        [endDateEvent setDateFormat:@"HH:mm"];
        NSString *endEventDateString = [endDateEvent stringFromDate:event.endDate];
        [endDateEvent release];
        if (self.eventDescription2 != nil)
        {
            [self.eventDescription2 removeFromSuperview];
        }
        self.eventDescription2 = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 96, screenWidth - 80, 49)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
        if (hour > 8 && hour < 20) {
            descriptionLabel.textColor = [UIColor blackColor];
        } else {
            descriptionLabel.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
        } if (event.notes != nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@. It starts at %@ and it ends at %@.\nNotes: %@", event.title, startEventDateString, endEventDateString, event.notes];
        } else if (event.notes == nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@.\nIt starts at %@ and it ends at %@.", event.title, startEventDateString, endEventDateString];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            descriptionLabel.font = [descriptionLabel.font fontWithSize:18];
        else
            descriptionLabel.font = [descriptionLabel.font fontWithSize:12];
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        CGRect myFrame = descriptionLabel.frame;
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, screenWidth - 80, myFrame.size.height);
        descriptionLabel.frame = myFrame;
        [self.eventDescription2 setContentSize:CGSizeMake(descriptionLabel.frame.size.width, descriptionLabel.frame.size.height)];
        [self.eventDescription2 addSubview:descriptionLabel];
        [_eventViewDay2 addSubview:self.eventDescription2];
    }
    else if (tableView.tag == 1003) {
        EKEvent *event = [_events3 objectAtIndex:indexPath.row];
        NSDateFormatter *startDateEvent = [[NSDateFormatter alloc]init];
        [startDateEvent setDateFormat:@"HH:mm"];
        NSString *startEventDateString = [startDateEvent stringFromDate:event.startDate];
        [startDateEvent release];
        NSDateFormatter *endDateEvent = [[NSDateFormatter alloc]init];
        [endDateEvent setDateFormat:@"HH:mm"];
        NSString *endEventDateString = [endDateEvent stringFromDate:event.endDate];
        [endDateEvent release];
        if (self.eventDescription3 != nil)
        {
            [self.eventDescription3 removeFromSuperview];
        }
        self.eventDescription3 = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 96, screenWidth - 80, 49)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
        if (hour > 8 && hour < 20) {
            descriptionLabel.textColor = [UIColor blackColor];
        } else {
            descriptionLabel.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
        } if (event.notes != nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@. It starts at %@ and it ends at %@.\nNotes: %@", event.title, startEventDateString, endEventDateString, event.notes];
        } else if (event.notes == nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@.\nIt starts at %@ and it ends at %@.", event.title, startEventDateString, endEventDateString];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            descriptionLabel.font = [descriptionLabel.font fontWithSize:18];
        else
            descriptionLabel.font = [descriptionLabel.font fontWithSize:12];
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        CGRect myFrame = descriptionLabel.frame;
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, screenWidth - 80, myFrame.size.height);
        descriptionLabel.frame = myFrame;
        [self.eventDescription3 setContentSize:CGSizeMake(descriptionLabel.frame.size.width, descriptionLabel.frame.size.height)];
        [self.eventDescription3 addSubview:descriptionLabel];
        [_eventViewDay3 addSubview:self.eventDescription3];
    }
    else if (tableView.tag == 1004) {
        EKEvent *event = [_events4 objectAtIndex:indexPath.row];
        NSDateFormatter *startDateEvent = [[NSDateFormatter alloc]init];
        [startDateEvent setDateFormat:@"HH:mm"];
        NSString *startEventDateString = [startDateEvent stringFromDate:event.startDate];
        [startDateEvent release];
        NSDateFormatter *endDateEvent = [[NSDateFormatter alloc]init];
        [endDateEvent setDateFormat:@"HH:mm"];
        NSString *endEventDateString = [endDateEvent stringFromDate:event.endDate];
        [endDateEvent release];
        if (self.eventDescription4 != nil)
        {
            [self.eventDescription4 removeFromSuperview];
        }
        self.eventDescription4 = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 96, screenWidth - 80, 49)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
        if (hour > 8 && hour < 20) {
            descriptionLabel.textColor = [UIColor blackColor];
        } else {
            descriptionLabel.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
        } if (event.notes != nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@. It starts at %@ and it ends at %@.\nNotes: %@", event.title, startEventDateString, endEventDateString, event.notes];
        } else if (event.notes == nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@.\nIt starts at %@ and it ends at %@.", event.title, startEventDateString, endEventDateString];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            descriptionLabel.font = [descriptionLabel.font fontWithSize:18];
        else
            descriptionLabel.font = [descriptionLabel.font fontWithSize:12];
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        CGRect myFrame = descriptionLabel.frame;
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, screenWidth - 80, myFrame.size.height);
        descriptionLabel.frame = myFrame;
        [self.eventDescription4 setContentSize:CGSizeMake(descriptionLabel.frame.size.width, descriptionLabel.frame.size.height)];
        [self.eventDescription4 addSubview:descriptionLabel];
        [_eventViewDay4 addSubview:self.eventDescription4];
    }
    else if (tableView.tag == 1005) {
        EKEvent *event = [_events5 objectAtIndex:indexPath.row];
        NSDateFormatter *startDateEvent = [[NSDateFormatter alloc]init];
        [startDateEvent setDateFormat:@"HH:mm"];
        NSString *startEventDateString = [startDateEvent stringFromDate:event.startDate];
        [startDateEvent release];
        NSDateFormatter *endDateEvent = [[NSDateFormatter alloc]init];
        [endDateEvent setDateFormat:@"HH:mm"];
        NSString *endEventDateString = [endDateEvent stringFromDate:event.endDate];
        [endDateEvent release];
        if (self.eventDescription5 != nil)
        {
            [self.eventDescription5 removeFromSuperview];
        }
        self.eventDescription5 = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 96, screenWidth - 80, 49)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
        if (hour > 8 && hour < 20) {
            descriptionLabel.textColor = [UIColor blackColor];
        } else {
            descriptionLabel.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
        } if (event.notes != nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@. It starts at %@ and it ends at %@.\nNotes: %@", event.title, startEventDateString, endEventDateString, event.notes];
        } else if (event.notes == nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@.\nIt starts at %@ and it ends at %@.", event.title, startEventDateString, endEventDateString];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            descriptionLabel.font = [descriptionLabel.font fontWithSize:18];
        else
            descriptionLabel.font = [descriptionLabel.font fontWithSize:12];
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        CGRect myFrame = descriptionLabel.frame;
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, screenWidth - 80, myFrame.size.height);
        descriptionLabel.frame = myFrame;
        [self.eventDescription5 setContentSize:CGSizeMake(descriptionLabel.frame.size.width, descriptionLabel.frame.size.height)];
        [self.eventDescription5 addSubview:descriptionLabel];
        [_eventViewDay5 addSubview:self.eventDescription5];
    }
    else if (tableView.tag == 1006) {
        EKEvent *event = [_events6 objectAtIndex:indexPath.row];
        NSDateFormatter *startDateEvent = [[NSDateFormatter alloc]init];
        [startDateEvent setDateFormat:@"HH:mm"];
        NSString *startEventDateString = [startDateEvent stringFromDate:event.startDate];
        [startDateEvent release];
        NSDateFormatter *endDateEvent = [[NSDateFormatter alloc]init];
        [endDateEvent setDateFormat:@"HH:mm"];
        NSString *endEventDateString = [endDateEvent stringFromDate:event.endDate];
        [endDateEvent release];
        if (self.eventDescription6 != nil)
        {
            [self.eventDescription6 removeFromSuperview];
        }
        self.eventDescription6 = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 96, screenWidth - 80, 49)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
        if (hour > 8 && hour < 20) {
            descriptionLabel.textColor = [UIColor blackColor];
        } else {
            descriptionLabel.textColor = [UIColor colorWithRed:145.0f / 255.0f green:145.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
        } if (event.notes != nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@. It starts at %@ and it ends at %@.\nNotes: %@", event.title, startEventDateString, endEventDateString, event.notes];
        } else if (event.notes == nil) {
            descriptionLabel.text = [NSString stringWithFormat:@"The title of your event is %@.\nIt starts at %@ and it ends at %@.", event.title, startEventDateString, endEventDateString];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            descriptionLabel.font = [descriptionLabel.font fontWithSize:18];
        else
            descriptionLabel.font = [descriptionLabel.font fontWithSize:12];
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        CGRect myFrame = descriptionLabel.frame;
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, screenWidth - 80, myFrame.size.height);
        descriptionLabel.frame = myFrame;
        [self.eventDescription6 setContentSize:CGSizeMake(descriptionLabel.frame.size.width, descriptionLabel.frame.size.height)];
        [self.eventDescription6 addSubview:descriptionLabel];
        [_eventViewDay6 addSubview:self.eventDescription6];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell.isSelected == YES)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.3]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
           [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end