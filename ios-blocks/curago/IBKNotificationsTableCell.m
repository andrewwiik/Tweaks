//
//  IBKNotificationsTableCell.m
//  curago
//
//  Created by Matt Clarke on 30/07/2014.
//
//

#import "IBKNotificationsTableCell.h"
#import <BulletinBoard/BBAttachments.h>
#import <SpringBoard7.0/SBApplicationController.h>
#import <objc/runtime.h>

#define is_IOS8_3 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)

@interface BBBulletin (EHHH)
-(id)sectionDisplayName;
@end

@interface SBApplication : NSObject
-(id)displayName;
@end

@interface SBApplicationController (iOS8)
- (id)applicationWithBundleIdentifier:(id)arg1;
@end

@implementation IBKNotificationsTableCell

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+(BOOL)isSuperviewColourationBright:(UIColor*)color {
    BOOL isLight = NO;
    
    CGDataProviderRef provider = CGImageGetDataProvider([IBKNotificationsTableCell imageWithColor:color].CGImage);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    
    if ([data length] > 0) {
        const UInt8 *pixelBytes = [data bytes];
        
        // Whether or not the image format is opaque, the first byte is always the alpha component, followed by RGB.
        UInt8 pixelR = pixelBytes[1];
        UInt8 pixelG = pixelBytes[2];
        UInt8 pixelB = pixelBytes[3];
        
        // Calculate the perceived luminance of the pixel; the human eye favors green, followed by red, then blue.
        double percievedLuminance = 1 - (((0.299 * pixelR) + (0.587 * pixelG) + (0.114 * pixelB)) / 255);
        
        pixelBytes = nil;
        
        isLight = percievedLuminance < 0.2;
    }
    
    data = nil;
    
    return isLight;
}

-(void)initialiseForBulletin:(BBBulletin*)bulletin andRowWidth:(CGFloat)width {
    // Initialiation: title, date label and content
    // content may be the count of -(id)attachments
    // date label: minutes (1m ago), hours (2h ago), days (up to 3d ago?), actual date.
    // attachment image - just take the first one
    
    // We have a height of 52.0 per cell.
    
    self.bulletin = bulletin;
    
    if (!self.translations) {
        self.translations = [NSBundle bundleWithPath:@"/System/Library/CoreServices/SpringBoard.app"];
    }
    
    if (!self.title) {
        self.title = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 3, width-8, (isIpadDevice ? 16 : 14))];
        self.title.numberOfLines = 1;
        self.title.backgroundColor = [UIColor clearColor];

        [self.title setLabelSize:kIBKLabelSizingSmallBold];
        self.title.shadowingEnabled = ![IBKNotificationsTableCell isSuperviewColourationBright:self.superviewColouration];
        
        if ([IBKNotificationsTableCell isSuperviewColourationBright:self.superviewColouration])
            self.title.textColor = [UIColor darkTextColor];
        else
            self.title.textColor = [UIColor whiteColor];
        
        [self addSubview:self.title];
    }
    
    self.title.text = [bulletin title];
    
    if (!self.title.text || [self.title.text isEqualToString:@""]) {
        SBApplication *app;
        if ([(SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance] respondsToSelector:@selector(applicationWithDisplayIdentifier:)])
            app = [(SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:[bulletin sectionID]];
        else
            app = [(SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:[bulletin sectionID]];
        
        self.title.text = [app displayName]; // Translate to app name
    }
    
    [self.title sizeToFit];
    
    CGRect titleFrameCleanUp = self.title.frame;
    if (titleFrameCleanUp.size.width > width-46) {
        titleFrameCleanUp.size = CGSizeMake(width-46, titleFrameCleanUp.size.height);
        self.title.frame = titleFrameCleanUp;
    }
    
    if (!self.dateLabel) {
        self.dateLabel = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 5, width-2, (isIpadDevice ? 13 : 12))];
        self.dateLabel.numberOfLines = 1;
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        
        [self.dateLabel setLabelSize:kIBKLabelSizingTiny];
        self.dateLabel.shadowingEnabled = ![IBKNotificationsTableCell isSuperviewColourationBright:self.superviewColouration];
        
        if ([IBKNotificationsTableCell isSuperviewColourationBright:self.superviewColouration])
            self.dateLabel.textColor = [UIColor darkTextColor];
        else
            self.dateLabel.textColor = [UIColor whiteColor];
        
        self.dateLabel.alpha = 0.5;
        
        [self addSubview:self.dateLabel];
    }
    
    self.dateTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateDate:) userInfo:nil repeats:YES];
    [self updateDate:nil];
    
    if (!self.content) {
        self.content = [[IBKLabel alloc] initWithFrame:CGRectMake(0, (isIpadDevice ? 21 : 19), width-4, (isIpadDevice ? 40 : 26))];
        //self.content.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        self.content.numberOfLines = 0;
        self.content.backgroundColor = [UIColor clearColor];
        
        [self.content setLabelSize:kIBKLabelSizingSmall];
        self.content.shadowingEnabled = ![IBKNotificationsTableCell isSuperviewColourationBright:self.superviewColouration];
        
        if ([IBKNotificationsTableCell isSuperviewColourationBright:self.superviewColouration])
            self.content.textColor = [UIColor darkTextColor];
        else
            self.content.textColor = [UIColor whiteColor];
        
        [self addSubview:self.content];
    }
    
    NSLog(@"Attachments");
    
    self.content.text = bulletin.message;
    
    if ([bulletin attachments]) {
        // Deal with attachment image
        // TODO: Finish attachment image handling
        
        NSLog(@"clientComposedImageInfos == %@", bulletin.attachments.clientSideComposedImageInfos);
        NSLog(@"Additional attachments == %@", bulletin.attachments.additionalAttachments);
        
        NSLog(@"ComposedAttachmentImage == %@", bulletin.composedAttachmentImage);
        
        if (!self.attachment) {
            self.attachment = [[UIImageView alloc] initWithImage:bulletin.composedAttachmentImage];
            
            // Recalculate image size based on height to sit it in.
            CGFloat percentage = 26/bulletin.composedAttachmentImageSize.height;
            CGFloat newWidth = bulletin.composedAttachmentImageSize.width/percentage;
            
            NSLog(@"Newwidth == %f", newWidth);
            
            self.attachment.frame = CGRectMake(4, (isIpadDevice ? 22 : 19), newWidth, (isIpadDevice ? 40 : 26));
            
            self.attachment.backgroundColor = [UIColor blueColor];
            self.attachment.alpha = 0.5;
            
            [self addSubview:self.attachment];
        }
    }
    
    if (!self.separatorLine) {
        self.separatorLine = [[UIView alloc] initWithFrame:CGRectMake(6, (isIpadDevice ? 65 : 50), width-16, 1)];
        self.separatorLine.backgroundColor = [UIColor whiteColor];
        self.separatorLine.alpha = 0.25;
        
        [self addSubview:self.separatorLine];
    }
}

-(void)updateDate:(NSTimer*)timer {
    //NSLog(@"I'm still getting called");
    
    @try {
        NSString *string;
        // calculate exact secs and mins, then vague 1h, 2h, then simply the time
        NSDate *now = [NSDate date];
        int seconds = (int)fabs([self.bulletin.date timeIntervalSinceDate:now]);
        seconds = floorf(seconds);
        int minutes = seconds / 60.0f;
        int hours = minutes / 60.0f;
        int days = hours / 24.0f;
        
        if (seconds < 10) {
            // Display "now"
            string = [self.translations localizedStringForKey:@"RELATIVE_DATE_NOW" value:@"now" table:@"SpringBoard"];
        } else if (seconds < 60) {
            // Display "%@s ago"
            string = [NSString stringWithFormat:[self.translations localizedStringForKey:@"RELATIVE_DATE_PAST_SEC" value:@"%@s ago" table:@"SpringBoard"], [NSString stringWithFormat:@"%d", seconds]];
        } else if (minutes < 60) {
            // Display "%@m ago"
            string = [NSString stringWithFormat:[self.translations localizedStringForKey:@"RELATIVE_DATE_PAST_MIN" value:@"%@m ago" table:@"SpringBoard"], [NSString stringWithFormat:@"%d", minutes]];
        } else if (hours < 24) {
            // Display "%@h ago"
            string = [NSString stringWithFormat:[self.translations localizedStringForKey:@"RELATIVE_DATE_PAST_HOUR" value:@"%@h ago" table:@"SpringBoard"], [NSString stringWithFormat:@"%d", hours]];
        } else {
            // Display "%@d ago"
            string = [NSString stringWithFormat:[self.translations localizedStringForKey:@"RELATIVE_DATE_PAST_DAY" value:@"%@d ago" table:@"SpringBoard"], [NSString stringWithFormat:@"%d", days]];
        }
        
        self.dateLabel.text = string;
    }
    @catch (NSException *exception) {
        NSLog(@"Bugger, I broke it again");
        
        // Kill that damn timer
        [self.dateTimer invalidate];
        self.dateTimer = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse {
    // Take everything out - title, time, timer and content
    
    self.title.text = @"";
    self.dateLabel.text = @"";
    self.content.text = @"";
    self.attachment.image = nil;
    [self.dateTimer invalidate];
}

@end
