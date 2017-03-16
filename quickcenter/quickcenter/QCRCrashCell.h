#import <Preferences/PSTableCell.h>
#import <CrashReport/libcrashreport.h>
#import "../common/crashlog_util.h"

@interface _UIAssetManager : NSObject
+ (id)assetManagerForBundle:(id)arg1;
@end

@interface PSTableCell (Creatix)
- (void)setFrameHeight:(CGFloat)arg1;
- (UIImageView *)iconImageView;
@end

@interface QCRCrashCell : PSTableCell
@property (nonatomic,strong) CRCrashReport *report;
@property (nonatomic,strong) NSString *syslogPath;
@property (nonatomic,strong) NSString *crashPath;
+ (nonnull UIColor*)defaultDetailTextColor;
@end