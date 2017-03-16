#import <Stocks/StockChartData.h>
#import <Stocks/StockGraphImageSet.h>

@class StockGraphImageSet;

%hook StockChartData

- (StockGraphImageSet *)imageSetForDisplayMode:(id)mode {
	NSMutableArray *imageSets = [[(NSMutableDictionary *)[self valueForKey:@"imageSetCache"] allValues] mutableCopy];
 	CGFloat topWidth = 0;
 	StockGraphImageSet *bestSet = nil;
 	for (StockGraphImageSet *imageSet in imageSets) {
 		if (imageSet.highlightOverlayImage.size.width > topWidth) {
 			bestSet = imageSet;
 			topWidth = imageSet.highlightOverlayImage.size.width;
 		}
 	}
 	if (bestSet) return bestSet;
 	else return %orig;
}

%end