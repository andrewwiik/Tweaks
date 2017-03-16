@interface PSSplitViewController : UIViewController
-(void)haha;
@end
%hook PSSplitViewController
%new
- (void)haha {
	UIImage *fakeImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Application Support/Curago/Images/fake.png"]];
	UIImageView *fakeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,26,375,641)];
	[self.view addSubview:fakeImageView];
	fakeImageView.image = fakeImage;

}
-(void)loadView {
	%orig;
	[self haha];
}
- (void)loadSubviews {
	%orig;
	[self haha];
}
%end