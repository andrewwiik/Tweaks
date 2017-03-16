@class CBRReadabilityManager;

@protocol CBRReadabilityManagerDelegate<NSObject>
@required
- (void)managersReadabilityStateDidChange:(CBRReadabilityManager *)manager;
@end

@interface CBRReadabilityManager : NSObject {

}

@property(nonatomic, assign) BOOL shouldUseDarkText;
@property(nonatomic, assign) id<CBRReadabilityManagerDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)refresh;
- (void)setShouldUseDarkTextAndSynchronize:(BOOL)useDarkText;

@end
