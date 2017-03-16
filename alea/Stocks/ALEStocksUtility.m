#import "ALEStocksUtility.h"

@implementation ALEStocksUtility

+ (NSString *)stockValueRounded:(NSString *)value decimalPlaces:(int)places {

	float tempValue = [value floatValue];
	CGFloat nearest = floorf(tempValue * pow(10,(double)places) + 0.5) / pow(10,(double)places);
	return [NSString stringWithFormat:@"%.2f", nearest];
}

@end