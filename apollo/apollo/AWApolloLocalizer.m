#import "AWApolloLocalizer.h"

@implementation AWApolloLocalizer

+(instancetype)sharedLocalizer {
	static dispatch_once_t p = 0;

	__strong static id _sharedSelf = nil;

	dispatch_once(&p,^{
		_sharedSelf = [[self alloc] init];
	});

	return _sharedSelf;
}

-(NSBundle *)localizationBundle {
	return [NSBundle bundleWithPath:@"/Library/PreferenceBundles/Apollo.bundle"];
}

-(NSString *)localizedStringForKey:(NSString *)key inTable:(NSString *)table {
    return NSLocalizedStringFromTableInBundle(key,table,self.localizationBundle,nil);
}

-(NSString *)localizedStringForKey:(NSString *)key {
	return [self localizedStringForKey:key inTable:nil];
}

-(void)loadLocalizedSpecifiersForSpecifiers:(NSArray *)specifiers intoArray:(NSArray **)outArray {
    NSArray *specs = [self localizedSpecifiersForSpecifiers:specifiers];
    *outArray = specs;
}

-(NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)specifiers inTable:(NSString *)table {
    
    for(PSSpecifier *spec in specifiers) {
        
        if([spec name]) {
            [spec setName:[self localizedStringForKey:[spec name] inTable:table]];
        }

        NSString *footerText = [spec propertyForKey:@"footerText"];
        if (footerText) {
            [spec setProperty:[self localizedStringForKey:footerText inTable:table] forKey:@"footerText"];
        }
        
        if([spec titleDictionary]) {
            
            NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
            
            for(NSString *key in [spec titleDictionary]) {
                [newTitles setObject:[self localizedStringForKey:[[spec titleDictionary] objectForKey:key] inTable:table] forKey:key];
            }
            
            [spec setTitleDictionary:newTitles];
        }
        
        if([spec shortTitleDictionary]) {
            
            NSMutableDictionary *newTitles = [NSMutableDictionary dictionary];
            
            for(NSString *key in [spec shortTitleDictionary]) {
                NSString *value = [[spec shortTitleDictionary] objectForKey:key];
                [newTitles setObject:[self localizedStringForKey:value inTable:table] forKey:key];
            }
            
            [spec setShortTitleDictionary:newTitles];
        }
        
    }
    
    return specifiers;
}

-(NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)specifiers {
   return [self localizedSpecifiersForSpecifiers:specifiers inTable:nil];
}

@end