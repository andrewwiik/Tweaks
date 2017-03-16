#import "headers.h"
%hook City
%new
+ (City *)cityFromZipCode:(NSString *)zipcode {

}
%end