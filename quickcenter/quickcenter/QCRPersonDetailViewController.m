//
//  New_PersonDetailViewController.m
//  test
//
//  Created by Brian Olencki on 3/10/16.
//  Copyright © 2016 bolencki13. All rights reserved.
//

#import "QCRPersonDetailViewController.h"
#import "QCRPersonCell.h"

#define URL_ENCODE(string) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(string), NULL, CFSTR(":/=,!$& '()*+;[]@#?"), kCFStringEncodingUTF8)

@implementation QCRPersonDetailViewController
@synthesize parentCell = _parentCell;
- (instancetype)initWithCell:(QCRPersonCell *)cell {
    if (self == [super initWithStyle:UITableViewStyleGrouped]) {
        _parentCell = cell;
        
//        self.navigationItem.title = [NSString stringWithFormat:@"About %@",[[_parentCell.name componentsSeparatedByString:@" "] objectAtIndex:0]];
        self.navigationItem.title = @"About";
        
        aryTableView = [NSMutableArray new];
        if (_parentCell.twitter != nil && ![_parentCell.twitter isEqualToString:@""]) {
            [aryTableView addObject:@"Twitter"];
        }
        if (_parentCell.facebook != nil && ![[_parentCell.facebook absoluteString] isEqualToString:@""]) {
            [aryTableView addObject:@"Facebook"];
        }
        if (_parentCell.github != nil && ![[_parentCell.github absoluteString] isEqualToString:@""]) {
            [aryTableView addObject:@"Github"];
        }
        if (_parentCell.website != nil && ![[_parentCell.website absoluteString] isEqualToString:@""]) {
            [aryTableView addObject:@"Website"];
        }
        if (_parentCell.email != nil && ![[_parentCell.email absoluteString] isEqualToString:@""]) {
            [aryTableView addObject:@"Email"];
        }
    
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0 || section == 1) {
        return 1;
    }
    
    NSInteger cells = 5;
    if (_parentCell.twitter == nil || [_parentCell.twitter isEqualToString:@""]) {
        cells--;
    }
    if (_parentCell.facebook == nil || [[_parentCell.facebook absoluteString] isEqualToString:@""]) {
        cells--;
    }
    if (_parentCell.github == nil || [[_parentCell.github absoluteString] isEqualToString:@""]) {
        cells--;
    }
    if (_parentCell.website == nil || [[_parentCell.website absoluteString] isEqualToString:@""]) {
        cells--;
    }
    if (_parentCell.email == nil || [[_parentCell.email absoluteString] isEqualToString:@""]) {
        cells--;
    }
    
    return cells;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == [NSIndexPath indexPathForItem:0 inSection:0]) {
        return 150;
    } else if (indexPath == [NSIndexPath indexPathForItem:0 inSection:1]) {
        return UITableViewAutomaticDimension;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"ABOUT";
    } else if (section == 2) {
        return @"SOCIAL";
    } else {
        return @"";
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath == [NSIndexPath indexPathForItem:0 inSection:0]) {
        cell.backgroundColor = tableView.backgroundColor;
        
        UIImageView *imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 7, 80, 80)];
        imgViewIcon.layer.cornerRadius = imgViewIcon.frame.size.height/2;
        imgViewIcon.image = _parentCell.iconLarge;
        imgViewIcon.center = CGPointMake(self.view.frame.size.width/2, imgViewIcon.center.y);
        [cell.contentView addSubview:imgViewIcon];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, imgViewIcon.frame.origin.y+imgViewIcon.frame.size.height+8, 200, 36)];
        lblName.attributedText = [self aboutMe];
        lblName.numberOfLines = 3;
        [lblName sizeToFit];
        lblName.center = CGPointMake(imgViewIcon.center.x, lblName.center.y); // 100/5*2-(100/5)/2
        lblName.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lblName];
    } else {
        if (indexPath == [NSIndexPath indexPathForItem:0 inSection:1]) {
            cell.textLabel.attributedText = [self bio];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.textLabel.text = [aryTableView objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if ([cell.textLabel.text isEqualToString:@"Twitter"]) {
                cell.imageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/quickcenter.bundle/twitter.png"];
            } else if ([cell.textLabel.text isEqualToString:@"Facebook"]) {
                cell.imageView.image = [UIImage imageNamed:@"Facebook.png"];
            } else if ([cell.textLabel.text isEqualToString:@"Github"]) {
                cell.imageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/quickcenter.bundle/github.png"];
            } else if ([cell.textLabel.text isEqualToString:@"Website"]) {
                cell.imageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/quickcenter.bundle/website.png"];
            } else if ([cell.textLabel.text isEqualToString:@"Email"]) {
                cell.imageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/quickcenter.bundle/email.png"];
            } 
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Twitter"]) {
        NSString *user = (__bridge NSString *)URL_ENCODE(_parentCell.twitter);
        NSURL *url = nil;
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"aphelion://"]]) {
            url = [NSURL URLWithString:[@"aphelion://profile/" stringByAppendingString:user]];
        } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
            url = [NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]];
        } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]]) {
            url = [NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]];
        } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings://"]]) {
            url = [NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]];
        } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
            url = [NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]];
        } else {
            url = [NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]];
        }
        [[UIApplication sharedApplication] openURL:url];
    } else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Facebook"]) {
        [[UIApplication sharedApplication] openURL:_parentCell.facebook];
    } else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Github"]) {
        [[UIApplication sharedApplication] openURL:_parentCell.github];
    } else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Website"]) {
        [[UIApplication sharedApplication] openURL:_parentCell.website];
    } else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Email"]) {
        [[UIApplication sharedApplication] openURL:_parentCell.email];
    }
}

#pragma mark - Other
- (NSMutableAttributedString*)bio {
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_parentCell.information]];
    
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attString length])];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [attString length])];
    
    return attString;
}
- (NSMutableAttributedString*)aboutMe {
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@\n%@",_parentCell.name, _parentCell.detailText, _parentCell.country]];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, [_parentCell.name length])];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [_parentCell.name length])];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([_parentCell.name length], [attString length]-[_parentCell.name length])];
    [attString addAttribute:NSForegroundColorAttributeName value:[QCRPersonCell defaultDetailTextColor] range:NSMakeRange([_parentCell.name length], [attString length]-[_parentCell.name length])];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:12] range:NSMakeRange([_parentCell.name length]+[_parentCell.detailText length]+2, [attString length]-[_parentCell.name length]-[_parentCell.detailText length]-2)];
    
    return attString;
}
@end
