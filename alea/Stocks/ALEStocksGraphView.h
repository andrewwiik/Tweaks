#import <Stocks/Stock.h>
#import <Stocks/StockGraphView.h>
#import <Stocks/StockChartDisplayMode.h>
#import <Stocks/StockChartData.h>
#import <Stocks/ChartUpdater.h>
#import <Stocks/StocksAssistantChartView.h>

@class Stock, StockChartData, StockGraphView, ALEStocksViewController, StockChartDisplayMode, StocksAssistantChartView;

@interface ALEStocksGraphView : UIView {
	Stock *_stock;
	ChartUpdater *_chartUpdater;
	BOOL _stockDataWillLoad;
	BOOL _graphViewNeedsUpdating;
}

@property (nonatomic, strong) StockChartDisplayMode *currentDisplayMode;
@property (nonatomic, strong) ALEStocksViewController *delegate;
@property (nonatomic, strong) StockChartData *graphData;
@property (nonatomic, strong) StocksAssistantChartView *graphView;

- (id)initWithStock:(Stock *)stock delegate:(ALEStocksViewController *)delegate interval:(int)interval;
- (void)updateChartWithStockData:(StockChartData *)stockData;
- (void)configureDisplayMode;

@end