#import "ALEStocksViewController.h"
#import "ALEStocksUtility.h"

@implementation ALEStocksViewController

- (id)initWithStock:(Stock *)stock interval:(int)interval {

	if(self = [super init]) {
		_stock = stock;
		_interval = interval;


	}
	return self;
}

- (void)viewDidLoad {

	[super viewDidLoad];

	_chartView.translatesAutoresizingMaskIntoConstraints = NO;

	[self setupBaseViews];
	[self setupStockDetailView];

}

- (void)loadView {

	[super loadView];
	UIView *view = [[UIView alloc] init];
   	self.view = view;
}

- (void)setupBaseViews {

	/* Start Stock Chart View Setup */

	_chartView = [[ALEStocksGraphView alloc] initWithStock:_stock delegate:self interval:_interval];
	_chartView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_chartView];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_chartView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_chartView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_chartView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_chartView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	/* End Stock Chart View Setup */

	/* Start Stock Detail View Setup */

	_stockDetailView = [[UIView alloc] init];
	_stockDetailView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview: _stockDetailView];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_stockDetailView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_stockDetailView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_stockDetailView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_stockDetailView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-15]];

	/* Edn Stock Detail View Setup */

	/* Start Vibrancy View Setup */

	UIBlurEffect *vibrancyBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
	_vibrancyView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:vibrancyBlurEffect]];
	_vibrancyView.translatesAutoresizingMaskIntoConstraints = NO;
	_vibrancyView.contentView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_vibrancyView];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	[_vibrancyView addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_vibrancyView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[_vibrancyView addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_vibrancyView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[_vibrancyView addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_vibrancyView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_vibrancyView addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_vibrancyView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	/* End Vibrancy View Setup */

	/* Start Divider View Setup */

	_dividerView = [[UIView alloc] init];
	_dividerView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.080];
	_dividerView.translatesAutoresizingMaskIntoConstraints = NO;
	[_vibrancyView.contentView addSubview:_dividerView];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dividerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dividerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dividerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dividerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	/* End Divider View Setup */
}

- (void)setupStockDetailView {

	/* Start Stock Symbol Label setup */

	_stockSymbolLabel = [[UILabel alloc] init];
	_stockSymbolLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:26];
	_stockSymbolLabel.text = _stock.companyName;
	_stockSymbolLabel.textColor = [UIColor blackColor];
	_stockSymbolLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_stockDetailView addSubview:_stockSymbolLabel];

	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_stockSymbolLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_stockDetailView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_stockSymbolLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_stockDetailView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

	/* End Stock Symbol Label Setup */

	/* Start Stock Company Label Setup */

	_stockCompanyLabel = [[UILabel alloc] init];
	_stockCompanyLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	_stockCompanyLabel.text = _stock.symbol;
	_stockCompanyLabel.textColor = [UIColor blackColor];
	_stockCompanyLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_stockDetailView addSubview:_stockCompanyLabel];

	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_stockCompanyLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_stockDetailView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_stockCompanyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_stockSymbolLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

	/* End Stock Company Label Setup */

	/* Start High Label Setup */

	_highLabel = [[UILabel alloc] init];
	_highLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	_highLabel.text = [NSString stringWithFormat:@"%@",[ALEStocksUtility stockValueRounded:_stock.high decimalPlaces:2]];
	_highLabel.textColor = [UIColor blackColor];
	_highLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_stockDetailView addSubview:_highLabel];

	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_highLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_stockDetailView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_highLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_stockCompanyLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

	/* End High Label Setup */

	/* Start Low Label Setup */

	_lowLabel = [[UILabel alloc] init];
	_lowLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	_lowLabel.text = [NSString stringWithFormat:@"%@",[ALEStocksUtility stockValueRounded:_stock.low decimalPlaces:2]];
	_lowLabel.textColor = [UIColor blackColor];
	_lowLabel.alpha = 0.5;
	_lowLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_stockDetailView addSubview:_lowLabel];

	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_lowLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_highLabel attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_lowLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_highLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

	/* End Low Label Setup */

	/* Start Change Label Fake Setup */

	// _changeLabel = [[UILabel alloc] init];
	// _changeLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:19.5];
	// if ([_stock changeIsNegative])
	// _changeLabel.text = [NSString stringWithFormat:@" %@ ",[ALEStocksUtility stockValueRounded:_stock.change decimalPlaces:2]];
	// else
	// _changeLabel.text = [NSString stringWithFormat:@" +%@ ",[ALEStocksUtility stockValueRounded:_stock.change decimalPlaces:2]];
	// _changeLabel.textColor = [UIColor clearColor];
	// //_lowLabel.alpha = 0.5;
	// _changeLabel.translatesAutoresizingMaskIntoConstraints = NO;
	// _changeLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
	// _changeLabel.layer.cornerRadius = 7;
	// _changeLabel.clipsToBounds = YES;
	// [_vibrancyView.contentView addSubview:_changeLabel];

	// [_vibrancyView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_changeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_vibrancyView.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-15]];
	// [_vibrancyView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_changeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_vibrancyView.contentView attribute:NSLayoutAttributeCenterY multiplier:0.5 constant:0]];

	/* End Change Label Fake Setup */

	/* Start Change Label Real Setup */

	_changeLabelReal = [[UILabel alloc] init];
	_changeLabelReal.font = [UIFont fontWithName:@".SFUIText-Light" size:20];
	if ([_stock changeIsNegative])
	_changeLabelReal.text = [NSString stringWithFormat:@" %@ ",[ALEStocksUtility stockValueRounded:_stock.change decimalPlaces:2]];
	else
	_changeLabelReal.text = [NSString stringWithFormat:@" +%@ ",[ALEStocksUtility stockValueRounded:_stock.change decimalPlaces:2]];
	_changeLabelReal.textColor = [UIColor blackColor];
	//_lowLabel.alpha = 0.5;
	_changeLabelReal.translatesAutoresizingMaskIntoConstraints = NO;
	[_stockDetailView addSubview:_changeLabelReal];

	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_changeLabelReal attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_stockDetailView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[_stockDetailView addConstraint:[NSLayoutConstraint constraintWithItem:_changeLabelReal attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_stockDetailView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

	/* End Change Label ReaL Setup */
}

- (void)chartUpdater:(ChartUpdater *)chartUpdater didReceiveStockChartData:(StockChartData *)stockData {

      [_chartView updateChartWithStockData:stockData];
}

- (void)chartUpdater:(ChartUpdater *)arg1 didFailWithError:(id)arg2 {

}

@end