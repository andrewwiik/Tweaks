//
//  IBKCreatorController.m
//  curago
//
//  Created by Matt Clarke on 18/03/2015.
//
//

#import "IBKCreatorController.h"
#import "IBKCreatorCell.h"

@interface IBKCreatorController ()

@end

@implementation IBKCreatorController

-(NSArray*)specifiers {
    if (_specifiers == nil) {
		NSMutableArray *testingSpecs = [self loadSpecifiersFromPlistName:@"Creators" target:self];
        
        _specifiers = testingSpecs;
    }
    
	return _specifiers;
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath*)arg2 {
    UITableViewCell *cell = [super tableView:arg1 cellForRowAtIndexPath:arg2];
    IBKCreatorCell *newCell = [[IBKCreatorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IBK-CellCreator"];
    
    newCell.textLabel.text = cell.textLabel.text;
    newCell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    newCell.detailTextLabel.numberOfLines = 0;
    newCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImage *image;
    
    switch (arg2.row) {
        case 0: // Jay
            if (arg2.section == 0) {
                newCell.detailTextLabel.text = @"\nI'm a UX/UI & Branding Architect. I design stuff.";
                image = [UIImage imageWithContentsOfFile:[[[self bundle] bundlePath] stringByAppendingString:@"/CreatorImages/JayMachalani.png"]];
            } else {
                newCell.detailTextLabel.text = @"\nAn enthusiast for minimalistic design.";
                image = [UIImage imageWithContentsOfFile:[[[self bundle] bundlePath] stringByAppendingString:@"/CreatorImages/Matchstic.png"]];
            }
            break;
        case 1:
            if (arg2.section == 0) {
                newCell.detailTextLabel.text = @"\nI'm an UI/UX iOS Designer • #Confero • #Vex • #QuickMusic2 • @AtomDevTeam";
                image = [UIImage imageWithContentsOfFile:[[[self bundle] bundlePath] stringByAppendingString:@"/CreatorImages/Aesign.png"]];
            } else {
                newCell.detailTextLabel.text = @"\nMassive  Fan • Member of @AtomDevTeam";
                image = [UIImage imageWithContentsOfFile:[[[self bundle] bundlePath] stringByAppendingString:@"/CreatorImages/gabrielefilipp5.png"]];
            }
            break;
        default:
            break;
    }
    
    newCell.imageView.image = image;
    
    return newCell;
}

- (void)tableView:(UITableView*)arg1 didSelectRowAtIndexPath:(NSIndexPath*)arg2 {
    [arg1 deselectRowAtIndexPath:arg2 animated:YES];
    
    // Launch to twitter
    NSString *user = @"phillipten";
    
    switch (arg2.row) {
        case 0: // Jay
            if (arg2.section == 0) {
                user = @"technofou";
            } else {
                user = @"_Matchstic";
            }
            break;
        case 1:
            if (arg2.section == 0) {
                user = @"achiarlitti98";
            } else {
                user = @"gabrielefilipp5";
            }
            break;
        default:
            break;
    }
    
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
	
	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
	
	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
	
	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
	
	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

- (CGFloat)tableView:(id)arg1 heightForRowAtIndexPath:(id)arg2 {
    return 100.0;
}

@end
