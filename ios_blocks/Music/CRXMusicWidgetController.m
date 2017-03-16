@implementation CRXMusicWidgetController

- (id)init {

	if(self = [super init]) {
		
	}
	return self;
}

+ (CRXMusicWidgetController *)sharedInstance {

  static dispatch_once_t p = 0;

  __strong static id _sharedObject = nil;

  dispatch_once(&p, ^{
    _sharedObject = [[self alloc] init];
  });

  return _sharedObject;
}



- (void)viewDidLoad {
	

}


@end