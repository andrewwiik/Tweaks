//
//  IBKGameCenterTableView.m
//  curago
//
//  Created by Matt Clarke on 10/02/2015.
//
//

#import "IBKGameCenterTableView.h"
#import <GameCenterFoundation/GKAchievementDescription.h>
#import <GameCenterFoundation/GKAchievementInternal.h>
#import <GameCenterFoundation/GKGame.h>
#import "IBKGameCenterTableCell.h"
#import "CKBlurView.h"
#import <objc/runtime.h>

@implementation IBKGameCenterTableView

-(id)initWithIdentifier:(NSString*)identifier andFrame:(CGRect)frame andColouration:(UIColor*)color {
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    
    if (self) {
        // Initialise our data sources etc.
        self.identifier = identifier;
        self.superviewColoration = color;
        
        self.backgroundColor = [UIColor clearColor];
        self.rowHeight = 30.0;
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.allowsSelection = NO;
        
        self.loading = [[IBKLabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width-40, self.frame.size.height-20)];
        self.loading.textAlignment = NSTextAlignmentCenter;
        self.loading.text = @"Loading";
        self.loading.numberOfLines = 0;
        self.loading.textColor = ([IBKNotificationsTableCell isSuperviewColourationBright:color] ? [UIColor darkTextColor] : [UIColor whiteColor]);
        self.loading.alpha = 0.0;
        //self.loading.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        
        [self.loading setLabelSize:kIBKLabelSizingMedium];
        
        [self addSubview:self.loading];
        
        self.ring = [[M13ProgressViewRing alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        self.ring.showPercentage = NO; // Do you want to show the percentage in the middle?
        self.ring.primaryColor = ([IBKNotificationsTableCell isSuperviewColourationBright:color] ? [UIColor darkTextColor] : [UIColor whiteColor]); //The outher color of the ring
        self.ring.secondaryColor = [UIColor colorWithWhite:1.0 alpha:0.6]; //The inner color of the ring
        self.ring.indeterminate = YES;// Means that the ring will go in loop
        
        self.ring.center = self.center;
        
        [self addSubview:self.ring];
        
        [self registerClass:[IBKGameCenterTableCell class] forCellReuseIdentifier:@"gcTableCell"];
        
        // Pull acheivements in!
        
        GKGame * __block game;
        
        [objc_getClass("GKGame") loadGamesWithBundleIDs:[NSArray arrayWithObject:self.identifier] withCompletionHandler:^(NSArray *games, NSError *error) {
            game = [games objectAtIndex:0];
            
            [self initialiseProper:game];
            
            NSLog(@"ERRROOOORRRRR: %@", error);
        }];
    }
    
    return self;
}

-(void)initialiseProper:(GKGame*)game {
    [objc_getClass("GKAchievementDescription") loadAchievementDescriptionsForGame:game withCompletionHandler:^(NSArray *arr, NSError *error) {
        if (!error || arr) {
            self.data = [self bubbleSort:[arr mutableCopy]];
            
            // We now need to sort our achievements by percentage done.
            [UIView animateWithDuration:0.3 animations:^{
                self.ring.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.ring removeFromSuperview];
                self.ring = nil;
            }];
            
            self.loading.alpha = 0.0;
            [self.loading removeFromSuperview];
            self.loading = nil;
        } else {
            // Oh dog's bollocks. We have to display no connection possible, and retry when we have connection...!
            self.data = [NSMutableArray array];
            
            if (error.code == 15) {
                self.loading.text = @"Please ensure you have logged into Game Center to load achievements";
            } else if (error.code == -1009) {
                self.loading.text = @"Please connect to WiFi or cellular data to download achievements";
            } else {
                self.loading.text = @"An unknown error occurred whilst downloading achievements";
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                self.loading.alpha = 1.0;
                self.ring.alpha = 0.0;
            }];
        }
        
        NSLog(@"ERRROOOORRRRR: %@", error.userInfo);
        
        [self reloadData];
    }];
    
    // Also, register ourselves for possible updates via notifications

}

-(NSMutableArray*)bubbleSort:(NSMutableArray*)array {
    int max = (int)array.count - 1;
    int swaps = 1;
    
    while (swaps != 0) {
        swaps = 0;
        for (int count = 0; count < max; count++) {
            //CGFloat valOne = [array[count] internal].percentComplete;
            //CGFloat valTwo = [array[count+1] internal].percentComplete;
            
            GKAchievementDescription *descOne = array[count];
            GKAchievementDescription *decTwo = array[count+1];
            
            /*if (valTwo < valOne) {
                array[count] = decTwo;
                array[count+1] = descOne;
                
                swaps++;
            }*/
        }
        
        max--;
    }
    
    return array;
}

#pragma mark Delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GKAchievementDescription *desc = self.data[indexPath.row];
    
    IBKGameCenterTableCell *cell = [self dequeueReusableCellWithIdentifier:@"gcTableCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[IBKGameCenterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gcTableCell"];
    }
    
    cell.desc = desc;
    [cell setupForDescriptionWithColor:self.superviewColoration];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
