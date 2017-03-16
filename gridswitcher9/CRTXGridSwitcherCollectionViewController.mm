#import "headers/headers.h"
#import "CRTXGridSwitcherCollectionViewItemViewCell.h"

@interface CRTXGridSwitcherCollectionViewController : UIViewController <SBDeckSwitcherItemContainerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *_switcherItems;
    NSMutableArray *_displayItems;
    SBDeckSwitcherPageViewProvider *_snapshotProvider;
    UICollectionViewFlowLayout *_flowLayout;
}

@property (nonatomic, strong) UICollectionView *collectionView;

- (double)minimumVerticalTranslationForKillingOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (void)scrollViewKillingProgressUpdated:(double)arg1 ofContainer:(SBDeckSwitcherItemContainer *)arg2;
- (CGRect)frameForPageViewOfContainer:(SBDeckSwitcherItemContainer *)arg1 fullyPresented:(BOOL)arg2;
- (void)selectedDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (BOOL)canSelectDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 numberOfTaps:(long long)arg2;
- (void)killDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 withVelocity:(double)arg2;
- (BOOL)shouldShowIconAndLabelOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (BOOL)isDisplayItemOfContainerRemovable:(SBDeckSwitcherItemContainer *)arg1;

@end

@implementation CRTXGridSwitcherCollectionViewController

- (id)init {
    if (self = [super init]) {
        
        _snapshotProvider = [[NSClassFromString(@"SBDeckSwitcherPageViewProvider") alloc] initWithDelegate:nil];
        _switcherItems = [NSMutableArray new];
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadItems];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,414,736) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[NSClassFromString(@"CRTXGridSwitcherCollectionViewItemViewCell") class] forCellWithReuseIdentifier:@"CRTXGridSwitcherCollectionViewItemViewCell"];
    [self.view addSubview:_collectionView];

    [_collectionView reloadData];
}

- (void)loadItems {

    _displayItems = [[NSClassFromString(@"SBAppSwitcherModel") sharedInstance] valueForKey:@"_recentDisplayItems"];
    
    for (SBDisplayItem *displayItem in _displayItems) {
        
        SBDeckSwitcherItemContainer *itemContainer = [[NSClassFromString(@"SBDeckSwitcherItemContainer") alloc] initWithFrame:CGRectMake(0,0,414,736) displayItem:displayItem delegate:self];
        SBAppSwitcherSnapshotView *snapshotView = [_snapshotProvider _snapshotViewForDisplayItem:displayItem preferringDownscaledSnapshot:NO synchronously:NO];
        SBDeckSwitcherPageView *pageView = [[NSClassFromString(@"SBDeckSwitcherPageView") alloc] initWithFrame:CGRectMake(0,0,414,736)];
        
        [snapshotView _loadSnapshotSyncPreferringDownscaled:YES];
        pageView.orientation = 1;
        [snapshotView setValue:@1 forKey:@"_orientation"];
        [snapshotView layoutSubviews];
        pageView.orientation = 1;
		[pageView setView:snapshotView animated:NO];
		pageView.orientation = 1;
		itemContainer.pageView = pageView;
		itemContainer.contentBlurRadiusProgress = 0;
		[itemContainer _addIconSubview];
		
		[_switcherItems addObject:itemContainer];
		
        NSLog(@"Display Item: %@", displayItem);
    
    }
}

- (double)minimumVerticalTranslationForKillingOfContainer:(SBDeckSwitcherItemContainer *)arg1 {

	return 100;
}

- (void)scrollViewKillingProgressUpdated:(double)arg1 ofContainer:(SBDeckSwitcherItemContainer *)arg2 {

}

- (CGRect)frameForPageViewOfContainer:(SBDeckSwitcherItemContainer *)arg1 fullyPresented:(BOOL)arg2 {

	return CGRectMake(0,0,414,736);
}

- (void)selectedDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 {

}

- (BOOL)canSelectDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 numberOfTaps:(long long)arg2 {

	return YES;
}

- (void)killDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 withVelocity:(double)arg2 {

}

- (BOOL)shouldShowIconAndLabelOfContainer:(SBDeckSwitcherItemContainer *)arg1 {

	return YES;
}

- (BOOL)isDisplayItemOfContainerRemovable:(SBDeckSwitcherItemContainer *)arg1 {

	return YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [_switcherItems count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"didSelectItemAtIndexPath:"
    //                                                                     message: [NSString stringWithFormat: @"Indexpath = %@", indexPath]
    //                                                              preferredStyle: UIAlertControllerStyleAlert];
    
    // UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Dismiss"
    //                                                       style: UIAlertActionStyleDestructive
    //                                                     handler: nil];
    
    // [controller addAction: alertAction];
    
    // [self presentViewController: controller animated: YES completion: nil];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CRTXGridSwitcherCollectionViewItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CRTXGridSwitcherCollectionViewItemViewCell" forIndexPath:indexPath];
    [cell setSwitcherItem:_switcherItems[indexPath.row]];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat switcherItemDimensionWidth = self.view.frame.size.width / 2.3f;
    CGFloat switcherItemDimensionHeight = self.view.frame.size.height / 2.3f;
    return CGSizeMake(switcherItemDimensionWidth - 20, switcherItemDimensionHeight - 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // CGFloat leftRightInset = self.view.frame.size.width / 14.0f;
    // CGFloat topDownInset = self.view.frame.size.height / 14.0f;
    return UIEdgeInsetsMake(40, 20, 40, 20);
}
@end