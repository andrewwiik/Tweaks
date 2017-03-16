#import "Preferences.h"

@implementation MoveCellPrefDetailListController

- (id)specifiers {
	if(_specifiers == nil) {
        
        _specifiers = [[self loadSpecifiersFromPlistName:@"MoveCellPrefDetail" target:self] retain];
        
	}
    
	return _specifiers;
}


@end
