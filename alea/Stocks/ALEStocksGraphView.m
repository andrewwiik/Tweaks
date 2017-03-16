#import "ALEStocksGraphView.h"
#import "ALEStocksViewController.h"
@implementation ALEStocksGraphView

- (id)initWithStock:(Stock *)stock delegate:(ALEStocksViewController *)delegate interval:(int)interval {

	if(self = [super init]) {

		_stock = stock;
		_chartUpdater = [NSClassFromString(@"ChartUpdater") new];
		[_chartUpdater setDelegate:delegate];
		_stockDataWillLoad = [_chartUpdater updateChartForStock:stock interval:interval];
		_graphView = [[NSClassFromString(@"StocksAssistantChartView") alloc] initWithFrame:CGRectMake(0,0,218, 63)];
		[_graphView setStock:stock];
		_currentDisplayMode = [_graphView valueForKey:@"displayMode"];
		[self configureDisplayMode];
		_delegate = delegate;
		_graphViewNeedsUpdating = YES;
		_graphView.translatesAutoresizingMaskIntoConstraints = NO;

	}
	return self;
}

- (void)layoutSubviews {

	[super layoutSubviews];

	if (!_graphView) {
		if (_graphData) {

			//[self configureDisplayMode];

			[self updateChartWithStockData:_graphData];


		}
	}
	if (_graphViewNeedsUpdating && _graphView && _graphData) {

		//[self configureDisplayMode];
		//[self readyChartForDisplay];
		_graphViewNeedsUpdating = NO;
	}
	if (![_graphView superview]) {
		[self addSubview:_graphView];
		[_graphView setFrame:CGRectMake(0,0,300, 78)];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:_graphView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:_graphView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:_graphView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:_graphView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
		//[_graphView readyForDisplayFromChartData];
	}
}

- (void)readyChartForDisplay {

	//[_graphView _processGraphDataForWidth:self.frame.size.width];
	//[_graphView recomputePathsAndRenderIfNeededForSize:self.frame.size];
}

- (void)updateChartWithStockData:(StockChartData *)stockData {

	_graphData = stockData;

	[_graphView setChartData:stockData];
	_graphViewNeedsUpdating = YES;
	[_graphView setFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
	[self layoutSubviews];
	

}

- (void)configureDisplayMode {

	_currentDisplayMode.lineColor = [UIColor blackColor];
	//_currentDisplayMode.lineWidth = [[NSNumber numberWithInt:(int)1] floatValue];
	_currentDisplayMode.showsVolume = NO;
	_currentDisplayMode.HUDEnabled = YES;
	_currentDisplayMode.chartSize = CGSizeMake(248,78);

	UIColor *lightGradientColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
	UIColor *darkGradientColor = [UIColor clearColor];
	
	CGFloat locations[2] = {1.0, 0.25};
	CFArrayRef colors = (__bridge CFArrayRef) [NSArray arrayWithObjects:(id)lightGradientColor.CGColor,
	                                  (id)darkGradientColor.CGColor, 
	                                  nil];
	
	CGColorSpaceRef colorSpc = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpc, colors, locations);
	_currentDisplayMode.backgroundGradient = gradient;
}

-(void)willRenderGraph:(id)arg1 withRenderOperation:(id)arg2 {

}

-(void)stockGraphViewReadyForDisplay:(StockGraphView *)graphView {
	//[_delegate stockGraphViewReadyForDisplay:graphView];
}

@end
