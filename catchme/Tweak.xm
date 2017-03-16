#import "ZKSwizzle.h"
#import <CoreLocation/CoreLocation.h>
// #import <CoreLocation/CoreLocation.h>
// @interface CRTXLocationManagerHack : NSObject
// - (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
// @end

// @implementation CRTXLocationManagerHack
// - (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
// 	for (CLLocation *location in locations) {
// 		NSLog(@"Got Location %@", location);
// 	}
// 	NSLog(@"Fuckin Hook That Shit");
// 	ZKOrig(void, manager, locations);
// }
// @end

static void hookShit() {
	int numberOfClasses = objc_getClassList(NULL, 0);
	Class *classList = (__unsafe_unretained Class *)malloc(sizeof(Class) * numberOfClasses);
	numberOfClasses = objc_getClassList(classList, numberOfClasses);

	for (int idx = 0; idx < numberOfClasses; idx++) 
	{
    	Class class1 = classList[idx];
    	NSLog(@"We Iterated Atleast Once");
    	if (class_getClassMethod(class1, @selector(locationManager:didUpdateLocations:))) {
	    	NSLog(@"THIS CLASS IMPLIMENTS THE SHIT WE NEED %@", class1);
		}
	}
	free(classList);
}


// NSMutableArray *stringStuff = [NSMutableArray new];
// for (NSString *class in stringStuff) {

// }
// @interface CRTXLocationManagerHack : NSObject
// @end


%hook UIApplication
%new
- (void)testPokeHooks {
	hookShit();
}
%end

%ctor {
	// hookShit();
}