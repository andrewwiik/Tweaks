%subclass shootArrow : NSObject
- (id)init {
	shootArrow = %orig;
	return shootArrow;
}
%new
-(void)performAction:(NSInteger)arg1 {
	if (arg1 == 1) [MusicSharedRemote handleTapOnControlType:1];
	else if(arg1 == 2) [MusicSharedRemote handleTapOnControlType:4];
}
%end
%ctor {
	shootArrow *shootArrow = [[%c(shootArrow) alloc] init];
}