#import "AWmusicsLogoTableCell.h"
#import "AWmusicsCustomHeaderView.h"
#import "AWmusicsPreferences.h"
#import <MobileGestalt/MobileGestalt.h>

@interface musicsListController: AWmusicsListController <MFMailComposeViewControllerDelegate>{
}
@end

@implementation musicsListController
-(id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [super specifiersForPlistName:@"musics"];
    }
    return _specifiers;
}

- (void)loadView {
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(tweetSupport:)];
}

-(void)viewDidLoad {
    UIImage *icon = [[UIImage alloc] initWithContentsOfFile:HEADER_ICON];
    icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    self.navigationItem.titleView = iconView;
    self.navigationItem.titleView.alpha = 0;

    [super viewDidLoad];

    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(increaseAlpha)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)increaseAlpha {
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.navigationItem.titleView.alpha = 1;
                }completion:nil];
}

- (void)tweetSupport:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [composeController setInitialText:@"#musics is awesome!"];
        
        [self presentViewController:composeController animated:YES completion:nil];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [composeController dismissViewControllerAnimated:YES completion:nil];
        };
        composeController.completionHandler = myBlock;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return (UIView *)[[AWmusicsCustomHeaderView alloc] init];
    } else if(section == 4){
        return (UIView *)[[AWmusicsLogoTableCell alloc] init];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 140.f;
    } else if(section == 4){
        return 30.f;
    }
    return (CGFloat)-1;
}

- (void)emailAW {
    MFMailComposeViewController *emailAW = [[MFMailComposeViewController alloc] init];
    [emailAW setSubject:@"musics Support"];
    [emailAW setToRecipients:[NSArray arrayWithObjects:@"Andrew Wiik", nil]];

    NSString *product = nil, *version = nil, *build = nil;

    
        product = (NSString *)MGCopyAnswer(kMGProductType);
        version = (NSString *)MGCopyAnswer(kMGProductVersion);
        build = (NSString *)MGCopyAnswer(kMGBuildVersion);

    [emailAW setMessageBody:[NSString stringWithFormat:@"\n\nCurrent Device: %@, iOS %@ (%@)", product, version, build] isHTML:NO];

    [emailAW addAttachmentData:[NSData dataWithContentsOfFile:@"/var/mobile//Library/Preferences/com.andywiik.music2.plist"] mimeType:@"application/xml" fileName:@"musicsPrefs.plist"];
    system("/usr/bin/dpkg -l >/tmp/dpkgl.log");
    [emailAW addAttachmentData:[NSData dataWithContentsOfFile:@"/tmp/dpkgl.log"] mimeType:@"text/plain" fileName:@"dpkgl.txt"];
    [self.navigationController presentViewController:emailAW animated:YES completion:nil];
    emailAW.mailComposeDelegate = self;
    [emailAW release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated: YES completion: nil];
}

@end