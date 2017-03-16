#import <UIKit/UIKit.h>
#import <Stocks/Stock.h>
#import <Stocks/StockGraphView.h>
#import <Stocks/ChartUpdater.h>
#import "ALEStocksGraphView.h"

@class Stock;
@class SPChartView;
@class StockChartData;
@class ChartUpdater;
@class ALEStocksGraphView;

@interface ALEStocksViewController : UIViewController {

	Stock *_stock;
	int _interval;
}

@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *changeLabelReal;
@property (nonatomic, strong) ALEStocksGraphView *chartView;
@property (nonatomic, strong) UIView *dividerView;
@property (nonatomic, strong) UILabel *highLabel;
@property (nonatomic, strong) UILabel *lowLabel;
@property (nonatomic, strong) UILabel *stockCompanyLabel;
@property (nonatomic, strong) UIView *stockDetailView;
@property (nonatomic, strong) UILabel *stockSymbolLabel;
@property (nonatomic, strong) UIVisualEffectView *vibrancyView;

- (id)initWithStock:(Stock *)stock interval:(int)interval;
- (void)chartUpdater:(ChartUpdater *)arg1 didFailWithError:(id)arg2;
- (void)chartUpdater:(ChartUpdater *)chartUpdater didReceiveStockChartData:(StockChartData *)stockData;
- (void)setupBaseViews;
- (void)setupStockDetailView;
@end