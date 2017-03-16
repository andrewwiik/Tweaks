@import GoogleMobileAds;
#include "BNARootListController.h"

@implementation BNARootListController

- (NSArray *)specifiers {
  if (!_specifiers) {
    _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    NSMutableArray *modifiedSpecs = [NSMutableArray new];
    PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@""
                                                        target:self
                                                           set:NULL
                                                           get:NULL
                                                        detail:Nil
                                                          cell:-1
                                                          edit:Nil];
            [specifier setProperty:NSClassFromString(@"ACUIAppInstallCell") forKey:@"cellClass"];
            [specifier setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/product.png"] forKey:@"ACUIAppInstallIcon"];
            [specifier setProperty:@"Creatix" forKey:@"ACUIAppInstallPublisher"];
            [specifier setProperty:@"Banana" forKey:@"ACUIAppInstallName"];
            [specifier setProperty:[NSNumber numberWithInt:81] forKey:@"height"];
            [specifier setProperty:@YES forKey:@"ACUIAppIsAvailable"];
            [specifier setProperty:@YES forKey:@"enabled"];
            [specifier setProperty:@YES forKey:@"Custom"];
            [specifier setProperty:@"Installed" forKey:@"CustomTitle"];
            [modifiedSpecs addObject:specifier];
            /*PSSpecifier* stepper = [PSSpecifier preferenceSpecifierNamed:@""
                                                        target:self
                                                           set:NULL
                                                           get:@selector(stringValueForSpecifier:)
                                                        detail:Nil
                                                          cell:4
                                                          edit:Nil];
            [stepper setProperty:NSClassFromString(@"AXEditableTableCellWithStepper") forKey:@"cellClass"];
            [stepper setProperty:@"NumericalPreferencePickerIdentifier" forKey:@"id"];
            [stepper setProperty:@"time" forKey:@"key"];
            [stepper setProperty:[NSNumber numberWithFloat:15.0] forKey:@"maximumValue"];
            [stepper setProperty:[NSNumber numberWithFloat:0.1] forKey:@"minimumValue"];
            [stepper setProperty:[NSNumber numberWithFloat:0.1] forKey:@"stepValue"];
            [modifiedSpecs addObject:stepper];*/
      [modifiedSpecs addObjectsFromArray:_specifiers];
      _specifiers = [modifiedSpecs copy];
      /*if ([_prefs boolForKey:@"Enabled"] == NO) {
       [[_specifiers specifierForID:@"CONFIGURATION"] setProperty:@NO forKey:@"enabled"];
       [[_specifiers specifierForID:@"SECURITY"] setProperty:@NO forKey:@"enabled"];
      }
      else {
      [[_specifiers specifierForID:@"CONFIGURATION"] setProperty:@YES forKey:@"enabled"];
      [[_specifiers specifierForID:@"SECURITY"] setProperty:@YES forKey:@"enabled"];
      }
      [self testEnable];*/
  }
 // [self testEnable];
  return _specifiers;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
  self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.bannerView];
  self.bannerView.hidden = YES;
  self.bannerView.delegate = self;
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
  // Replace this ad unit ID with your own ad unit ID.
  self.bannerView.adUnitID = @"ca-app-pub-9726509502990875/8247782740";
  self.bannerView.rootViewController = self;

  GADRequest *request = [GADRequest request];
  // Requests test ads on devices you specify. Your test device ID is printed to the console when
  // an ad request is made. GADBannerView automatically returns test ads when running on a
  // simulator.

  [self.bannerView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
  bannerView.hidden = NO;
}
@end
