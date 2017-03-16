#import <Stocks/StockGraphView.h>
#import <Stocks/StocksAssistantChartView.h>

@class StockGraphView;

%hook StocksAssistantChartView

- (void)stockGraphViewReadyForDisplay:(StockGraphView *)graphView {

	%orig;
	if ([graphView superview]) {

	[[graphView superview] addConstraint:[NSLayoutConstraint constraintWithItem:graphView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[graphView superview] attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[[graphView superview] addConstraint:[NSLayoutConstraint constraintWithItem:graphView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[graphView superview] attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[[graphView superview] addConstraint:[NSLayoutConstraint constraintWithItem:graphView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[graphView superview]  attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[[graphView superview] addConstraint:[NSLayoutConstraint constraintWithItem:graphView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[graphView superview] attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	}
	
}

-(void)_prepareXAxisLabelsAndPositions {

	return;
}
-(void)_prepareYAxisLabelsAndPositions {

	return;
}

- (void)layoutSubviews {

	%orig;

	if ([self valueForKey:@"graph"]) {

		StockGraphView *graphView = (StockGraphView *)[self valueForKey:@"graph"];

		if ([graphView superview]) {
			
			graphView.translatesAutoresizingMaskIntoConstraints = NO;
			[[[graphView superview] superview] addConstraint:[NSLayoutConstraint constraintWithItem:graphView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[[graphView superview] superview] attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
			[[[graphView superview] superview] addConstraint:[NSLayoutConstraint constraintWithItem:graphView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[[graphView superview] superview] attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
			[[[graphView superview] superview] addConstraint:[NSLayoutConstraint constraintWithItem:graphView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[[graphView superview] superview]  attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
			[[[graphView superview] superview] addConstraint:[NSLayoutConstraint constraintWithItem:graphView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[[graphView superview] superview] attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
			
			if ([graphView valueForKey:@"lineView"]) {

				UIView *lineView = (UIView *)[graphView valueForKey:@"lineView"];

				if ([lineView superview]) {

					lineView.translatesAutoresizingMaskIntoConstraints = NO;
					[graphView addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:graphView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
					[graphView addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:graphView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
					[graphView addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:graphView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
					[graphView addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:graphView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
				}
			}
		}
	}
}

%end

%ctor {
	NSString *fullPath = [NSString stringWithFormat:@"/System/Library/Assistant/UIPlugins/Stocks.siriUIBundle"];
	NSBundle *bundle;
	bundle = [NSBundle bundleWithPath:fullPath];
	if ([bundle load]) %init;
}