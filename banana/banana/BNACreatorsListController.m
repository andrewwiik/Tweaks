//
//  ViewController.m
//  test
//
//  Created by Brian Olencki on 1/6/16.
//  Copyright © 2016 bolencki13. All rights reserved.
//

#import "BNACreatorsListController.h"
#import "BNAPersonCell.h"
#import "BNAPersonDetailViewController.h"

@interface BNACreatorsListController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *aryItems;
}
@end

@implementation BNACreatorsListController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    aryItems = [@[
                  @"Stijn de Vries",
                  @"Metehan Turna",
                  @"Ariel Okhtenberg",
                  @"Noah Saso",
                  @"Brian Olencki",
                  @"Andrew Wiik",
                  @"Slackbot",
                  ] mutableCopy];
    
    UITableView *tblView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tblView.dataSource = self;
    tblView.delegate = self;
    self.view = tblView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [aryItems count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BNAPersonCell defaultCellHeight];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";
    BNAPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BNAPersonCell alloc] initWithName:[aryItems objectAtIndex:indexPath.row] reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath == [NSIndexPath indexPathForItem:0 inSection:0]) {
        cell.icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/creatix.png"];
        cell.iconLarge = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/creatix-lg.png"];
        cell.name = @"Creatix";
        cell.detailText = @"Team";
        cell.country = @"Global";
        //cell.icon = [UIImage imageNamed:[NSString stringWithFormat:@"creatix.png"]];
        cell.information = @"Creatix is a team of 3 designers and 3 developers who want to bring creative and wanted tweaks to the Jailbreak community. We are the team that will bring changes to the community by developing the most requested tweaks but also designing them so that they feel native to the iOS ecosystem. Often times jailbreak developers have great ideas, but they don't know how to execute their idea in a way that will provide useful functionality to the end users while still fitting natively into iOS. That's where we come in. We have very talented developers and designers on our team and because of that we are able to span the gap from design to production to provide tweaks that are useful and functional.\n\nWe are committed to changing what a user expects when they download a tweak. We are attempting to bring about this change by offering great support, listening to what the community has to say, acting transparent in what we do, being honest with every user, and treating every user with the respect that every human being is entitled to.";
        cell.twitter = [NSString stringWithFormat:@"ioscreatix"];
        cell.website = [NSURL URLWithString:@"https://ioscreatix.com/index.html"];
        cell.email = [NSURL URLWithString:@"mailto://ioscreatix@gmail.com"];
        return cell;
    }
    
    switch (indexPath.row) {
        case 5: /* Andrew Wiik */ {
            cell.icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/andy.png"];
            cell.iconLarge = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/andy-lg.png"];
            cell.detailText = @"Developer";
            cell.information = @"The first developer to join Creatix. He is an inquisitive and diligent person who doesn’t know the word ‘impossible.’ He stays up late until he reaches what he has been working for. Making him a person who doesn't give up very easily.";
            cell.country = @"USA";
            cell.twitter = [NSString stringWithFormat:@"andywiik"];
            cell.github = [NSURL URLWithString:@"https://github.com/andrewwiik"];
            cell.website = [NSURL URLWithString:@""];
            cell.email = [NSURL URLWithString:@"mailto://andy@ioscreatix.com"];
        } break;
        case 4: /* Brian Olencki */ {
            cell.icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/brian.png"];
            cell.iconLarge = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/brian-lg.png"];
            cell.detailText = @"Developer";
            cell.information = @"A very proficient 20 year old who goes to school at Johnson & Wales. He spends most, if not all his nights, programming and creating Jailbreak tweaks & updates his iOS apps such as WhirliBird & MapOut. In his free time, he is an eagle scout that enjoys traveling to exotic and different places";
            cell.country = @"USA";
            cell.twitter = [NSString stringWithFormat:@"bolencki13"];
            cell.github = [NSURL URLWithString:@"http://github.com/bolencki13"];
            cell.website = [NSURL URLWithString:@"http://cydia.bolencki13.com/repo"];
            cell.email = [NSURL URLWithString:@"mailto://brian@ioscreatix.com"];
        } break;
        case 3: /* Noah Saso */ {
            cell.icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/noah.png"];
            cell.iconLarge = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/noah-lg.png"];
            cell.detailText = @"Developer";
            cell.information = @"At 15 years old, Noah is a self-taught developer with a love of knowledge, perfectionism, and technology. When he's not doing homework, playing sports, or hanging out with friends, he does what he does best: create. He's always on the lookout for new projects or ideas to bring to life.";
            cell.country = @"USA";
            cell.twitter = [NSString stringWithFormat:@"NoahSaso"];
            cell.github = [NSURL URLWithString:@"http://github.com/NoahSaso"];
            cell.website = [NSURL URLWithString:@""];
            cell.email = [NSURL URLWithString:@"mailto://noah@ioscreatix.com"];
        } break;
        case 2: /* AOkhtenberg */ {
            cell.icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/ariel.png"];
            cell.iconLarge = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/ariel-lg.png"];
            cell.detailText = @"Designer";
            cell.information = @"As a co-founder of Creatix, he is an artistic and ingenious designer that has a passion for coding websites and Java applications. As a college student who attends New York University, he is very agile when it comes to designing. His main hobby is swimming and plans on participating in the Olympics.";
            cell.country = @"USA";
            cell.twitter = [NSString stringWithFormat:@"aokhtenberg"];
            cell.website = [NSURL URLWithString:@""];
            cell.email = [NSURL URLWithString:@"mailto://ariel@ioscreatix.com"];
        }break;
        case 1: /* byturna */ {
            cell.icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/turna.png"];
            cell.iconLarge = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/turna-lg.png"];
            cell.detailText = @"Designer";
            cell.information = @"Living in the Netherlands, Turna is the cofounder of Creatix. He is a very adept and talented designer that has been doing extravagant and simple design work for almost 5 years. Now that this team has been growing exponentially, he hopes to make all his tweak concepts come to reality.";
            cell.country = @"Netherlands";
            cell.twitter = [NSString stringWithFormat:@"byturna"];
            cell.website = [NSURL URLWithString:@""];
            cell.email = [NSURL URLWithString:@"mailto://turna@ioscreatix.com"];
        } break;
        case 0: /* stijn_d3sign */ {
            cell.icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/stijn.png"];
            cell.iconLarge = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/stijn-lg.png"];
            cell.detailText = @"Designer";
            cell.information = @"Coming from the Netherlands, Stijn is a skilled self-taught designer who has been working within the jailbreak community, trying to improve upon and create new concepts. Recently, he has been working with well-known developers to bring his concepts to life.";
            cell.country = @"Netherlands";
            cell.twitter = [NSString stringWithFormat:@"stijn_d3sign"];
            cell.github = [NSURL URLWithString:@"http://github.com/stijn_d3sign"];
            cell.website = [NSURL URLWithString:@""];
            cell.email = [NSURL URLWithString:@"mailto://stijn@ioscreatix.com"];
        } break;
        default: /* Default */ {
            cell.icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/slackbot.png"];
            cell.iconLarge = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/slackbot-lg.png"];
            cell.detailText = @"Sassy Team Member";
            cell.information = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
            cell.country = @"California, USA";
            cell.twitter = [NSString stringWithFormat:@"ioscreatix"];
            cell.github = [NSURL URLWithString:@""];
            cell.website = [NSURL URLWithString:@"https://ioscreatix.com/index.html"];
            cell.email = [NSURL URLWithString:@"mailto://slackbot@ioscreatix.com"];
        } break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    [self.navigationController pushViewController:[[BNAPersonDetailViewController alloc] initWithCell:[tableView cellForRowAtIndexPath:indexPath] withPersonInfoStyle:PersonInfoStyleNameSeparate] animated:YES];
    [self.navigationController pushViewController:[[BNAPersonDetailViewController alloc] initWithCell:[tableView cellForRowAtIndexPath:indexPath]] animated:YES];

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)loadView {
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/heart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heart)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:255.0f/255.0f
        green:58.0f/255.0f
         blue:45.0f/255.0f
        alpha:1.0f];
    [self setTitle:@"Creators"];
}

@end
