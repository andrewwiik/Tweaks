#import <Preferences/PSTableCell.h>
#import <CrashReport/libcrashreport.h>
#import "../common/crashlog_util.h"

@interface _UIAssetManager : NSObject
+ (nonnull id)assetManagerForBundle:(nonnull id)arg1;
@end

@interface PSTableCell (Creatix)
- (void)setFrameHeight:(CGFloat)arg1;
- (nonnull UIImageView *)iconImageView;
@end

@interface BNACrashCell : PSTableCell
@property (nonatomic,strong, nonnull) CRCrashReport *report;
@property (nonatomic,strong, nonnull) NSString *syslogPath;
@property (nonatomic,strong, nonnull) NSString *crashPath;
+ (nonnull UIColor*)defaultDetailTextColor;
@end