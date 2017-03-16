#include "QCRBugSubmitListController.h"
#import "CWStatusBarNotification.h"
@implementation QCRBugSubmitListController
- (NSArray *)specifiers {

	if (!_specifiers) {
		NSMutableArray *tempSpecs = [self loadSpecifiersFromPlistName:@"Bugs" target:self];
    _specifiers = [NSMutableArray new];
    _prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.quickcenter"];
    NSMutableArray *modifiedSpecs = [NSMutableArray new];
    PSSpecifier *crash = _specifier;
    if (crash) {
    _crashPath = [NSString stringWithFormat:@"%@", [crash propertyForKey:@"crashPath"]];
    _syslogPath = syslogPathForFile([NSString stringWithFormat:@"%@", _crashPath]);
     _report = [CRCrashReport crashReportWithFile:[crash propertyForKey:@"crashPath"] filterType:CRCrashReportFilterTypePackage];
     PSSpecifier *spec = [PSSpecifier preferenceSpecifierNamed:@"title"
                                                            target:self
                                                               set:NULL
                                                               get:NULL
                                                            detail:NSClassFromString(@"QCRBugSubmitListController")
                                                              cell:1
                                                              edit:Nil];
       [spec setProperty:NSClassFromString(@"QCRCrashCell") forKey:@"cellClass"];
       [spec setProperty:[crash propertyForKey:@"crashPath"] forKey:@"crashPath"];
       [spec setProperty:NSClassFromString(@"QCRBugSubmitListController") forKey:@"detail"];
       [spec setProperty:@YES forKey:@"enabled"];
       [spec setProperty:[NSNumber numberWithFloat:50.0] forKey:@"height"];
       [spec setProperty:@YES forKey:@"submitting"];
       [modifiedSpecs addObject:spec];
       PSSpecifier *infoLabel = [PSSpecifier preferenceSpecifierNamed:@"Details"
          target:self
             set:NULL
             get:NULL
          detail:Nil
            cell:PSGroupCell
            edit:Nil];
  [infoLabel setProperty:@"Details" forKey:@"label"];
  [infoLabel setProperty:[NSNumber numberWithInt:0] forKey:@"footerAlignment"];
  [infoLabel setProperty:[NSString stringWithFormat:@"Please fill in the fields above so we can contact you in case we need further details. After you have filled out all the fields please press 'Submit' and then go have a awesome day."] forKey:@"footerText"];
  [infoLabel setProperty:@"INFO_LABEL" forKey:@"id"];
  [modifiedSpecs addObject:infoLabel];
  PSTextFieldSpecifier *name = [PSTextFieldSpecifier preferenceSpecifierNamed:@"Name"
                                                       target:self
                                                          set:@selector(setPreferenceValue:specifier:)
   									                      get:@selector(readPreferenceValue:)
                                                       detail:Nil
                                                         cell:8
                                                         edit:Nil];
  [name setPlaceholder:[NSString stringWithFormat:@"John Appleseed"]];
  [name setProperty:@"NAME" forKey:@"id"];
  [modifiedSpecs addObject:name];

  PSTextFieldSpecifier *email = [PSTextFieldSpecifier preferenceSpecifierNamed:@"Email"
                                                       target:self
                                                          set:@selector(setPreferenceValue:specifier:)
   									   					  get:@selector(readPreferenceValue:)
                                                       detail:Nil
                                                         cell:8
                                                         edit:Nil];
  [email setPlaceholder:[NSString stringWithFormat:@"name@example.com"]];
  [email setProperty:@"EMAIL" forKey:@"id"];
  [modifiedSpecs addObject:email];

  PSTextFieldSpecifier *twitter = [PSTextFieldSpecifier preferenceSpecifierNamed:@"Twitter"
                                                       target:self
                                                          set:@selector(setPreferenceValue:specifier:)
   									   					  get:@selector(readPreferenceValue:)
                                                       detail:Nil
                                                         cell:8
                                                         edit:Nil];
  [twitter setPlaceholder:[NSString stringWithFormat:@"@name (Optional)"]];
  [twitter setProperty:@"TWITTER" forKey:@"id"];
  [modifiedSpecs addObject:twitter];

  PSSpecifier *tweak = [PSSpecifier preferenceSpecifierNamed:@"Tweak"
                                                      target:self
                                                         set:NULL
  									   					  get:@selector(getTweakName:)
                                                      detail:Nil
                                                        cell:4
                                                        edit:Nil];
  [tweak setProperty:[NSString stringWithFormat:@"Tweak"] forKey:@"label"];
  [tweak setProperty:@"TWEAK" forKey:@"id"];
  [tweak setProperty:[NSString stringWithFormat:@"com.creatix.quickcenter"] forKey:@"bundleID"];
  [modifiedSpecs addObject:tweak];

  PSSpecifier *version = [PSSpecifier preferenceSpecifierNamed:@"Version"
                                                      target:self
                                                         set:NULL
  									   					  get:@selector(getTweakVersion:)
                                                      detail:Nil
                                                        cell:4
                                                        edit:Nil];
  [version setProperty:[NSString stringWithFormat:@"Version"] forKey:@"label"];
  [version setProperty:@"VERSION" forKey:@"id"];
  [version setProperty:[NSString stringWithFormat:@"com.creatix.quickcenter"] forKey:@"bundleID"];
  [modifiedSpecs addObject:version];

  PSSpecifier *installDate = [PSSpecifier preferenceSpecifierNamed:@"Install Date"
                                                      target:self
                                                         set:NULL
  									   					  get:@selector(getTweakInstallDate:)
                                                      detail:Nil
                                                        cell:4
                                                        edit:Nil];
  [installDate setProperty:[NSString stringWithFormat:@"Install Date"] forKey:@"label"];
  [installDate setProperty:@"INSTALL_DATE" forKey:@"id"];
  [installDate setProperty:[NSString stringWithFormat:@"com.creatix.quickcenter"] forKey:@"bundleID"];
  [modifiedSpecs addObject:installDate];

  PSSpecifier *type = [PSSpecifier preferenceSpecifierNamed:@"Crash Type"
                                                      target:self
                                                         set:NULL
  									   					  get:@selector(getCrashType:)
                                                      detail:Nil
                                                        cell:4
                                                        edit:Nil];
  [type setProperty:[NSString stringWithFormat:@"Crash Type"] forKey:@"label"];
  [type setProperty:@"CRASH_TYPE" forKey:@"id"];
  [modifiedSpecs addObject:type];

  PSSpecifier *send = [PSSpecifier preferenceSpecifierNamed:@"Submit Bug Report"
                                                            target:self
                                                               set:NULL
                                                               get:NULL
                                                            detail:nil
                                                              cell:PSButtonCell
                                                              edit:nil];
	[send setProperty:@YES forKey:@"enabled"];
	[send setButtonAction:@selector(sendReport)];
	[modifiedSpecs addObject:send];

  [modifiedSpecs addObjectsFromArray:_specifiers];
	}
    _specifiers = [modifiedSpecs copy];
	}
	return _specifiers;
}
- (id)getCrashType:(PSSpecifier*)specifier {
	return [[_report processInfo] objectForKey:@"Exception Note"];

}
- (id)getTweakName:(PSSpecifier*)specifier {
	PIPackage *package = [PIPackage packageWithIdentifier:[specifier propertyForKey:@"bundleID"]];
	return [NSString stringWithFormat:@"%@", [package name]];
}
- (id)getTweakVersion:(PSSpecifier*)specifier {
	PIPackage *package = [PIPackage packageWithIdentifier:[specifier propertyForKey:@"bundleID"]];
	return [NSString stringWithFormat:@"%@", [package version]];
}
- (id)getTweakInstallDate:(PSSpecifier*)specifier {
	PIPackage *package = [PIPackage packageWithIdentifier:[specifier propertyForKey:@"bundleID"]];
	return [NSString stringWithFormat:@"%@", [package installDate]];
}


- (void)loadView {
	[super loadView];
  	[self setTitle:[NSString stringWithFormat:@"Submit Bug"]];
  	PSSpecifier *crash = _specifier;
  	if (crash) {
  		NSArray *specs = [self specifiers];
  		_specifiers = specs;
  	}
  	[self setTitle:[NSString stringWithFormat:@"Submit Bug"]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)_returnKeyPressed:(id)notification {
	[self.view endEditing:YES];
	//[super _returnKeyPressed:notification];
}

- (void)sendReport {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://ioscreatix.com/bugs/bug.php"]];
    
    NSData *crashReportData = [[NSData alloc] initWithContentsOfFile:_crashPath];
    NSData *syslogData = [[NSData alloc] initWithContentsOfFile:_syslogPath];

    NSString *name = [NSString stringWithFormat:@"%@",[[[_specifiers specifierForID:@"NAME"] propertyForKey:@"cellObject"] tableValue]];
    NSString *email = [NSString stringWithFormat:@"%@",[[[_specifiers specifierForID:@"EMAIL"] propertyForKey:@"cellObject"] tableValue]];
    NSString *twitter = [NSString stringWithFormat:@"%@",[[[_specifiers specifierForID:@"TWITTER"] propertyForKey:@"cellObject"] tableValue]];
    NSString *tweak = [NSString stringWithFormat:@"QuickCenter"];
    NSString *version =  [NSString stringWithFormat:@"%@",[[[_specifiers specifierForID:@"VERSION"] propertyForKey:@"cellObject"] tableValue]];
    NSString *installDate = [NSString stringWithFormat:@"%@",[[[_specifiers specifierForID:@"INSTALL_DATE"] propertyForKey:@"cellObject"] tableValue]];
    NSString *crashType = [NSString stringWithFormat:@"%@",[[[_specifiers specifierForID:@"CRASH_TYPE"] propertyForKey:@"cellObject"] tableValue]];

    NSString *problem = [NSString stringWithFormat:@"%@ crashed with %@", tweak, crashType];
    NSString *detail = [NSString stringWithFormat:@"%@ was installed on %@, the current installed version is %@", tweak, installDate, version];
    
    NSString *crashReportURL = [NSString stringWithFormat:@"%@.ips", [[_report processInfo] objectForKey:@"Incident Identifier"]];
    NSString *syslogURL = [NSString stringWithFormat:@"%@.syslog", [[_report processInfo] objectForKey:@"Incident Identifier"]];
    NSString *crashID = [NSString stringWithFormat:@"%@", [[_report processInfo] objectForKey:@"Incident Identifier"]];
    /*
    NSString *crashFileExtension = [_crashPath pathExtension];
    NSString *crashUTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)crashFileExtension, NULL);
    NSString *crashContentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)crashUTI, kUTTagClassMIMEType);

    NSString *syslogFileExtension = [_syslogPath pathExtension];
    NSString *syslogUTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)syslogFileExtension, NULL);
    NSString *syslogContentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)syslogUTI, kUTTagClassMIMEType);
    */
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"_187934598797439873422234";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    if (name) {
    	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"Name"] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"%@\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	if (email) {
    	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"Email"] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"%@\r\n", email] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	if (twitter) {
    	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"Twitter"] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"%@\r\n", twitter] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	if (tweak) {
    	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"Tweak"] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"%@\r\n", tweak] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	if (problem) {
    	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"Problem"] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"%@\r\n", problem] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	if (detail) {
    	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"Detail"] dataUsingEncoding:NSUTF8StringEncoding]];
    	[body appendData:[[NSString stringWithFormat:@"%@\r\n", detail] dataUsingEncoding:NSUTF8StringEncoding]];
	}
  if (crashID) {
      [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"uid"] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"%@\r\n", crashID] dataUsingEncoding:NSUTF8StringEncoding]];
  }
    // add image data
    if (crashReportData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", @"crash", crashReportURL] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:crashReportData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (syslogData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", @"syslog", syslogURL] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:syslogData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
             CWStatusBarNotification *notification = [CWStatusBarNotification new];
              notification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1];
              notification.notificationLabelTextColor = [UIColor blackColor];
              [notification displayNotificationWithMessage:[NSString stringWithFormat:@"Your bug report has been sent, please check your email shortly."]
                                       forDuration:2.0f];
              notification = nil;
                    }
                }];
}
- (void)resetSettings {
  
}
@end