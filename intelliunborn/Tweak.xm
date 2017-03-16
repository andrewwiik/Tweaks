@interface CyteWebView : UIWebView
- (void)reloadFromOrigin;
- (id)request;
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
@end
@interface UIView (privatea)
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
@end
@interface HomeController : UIViewController
@end

NSString *help = @"document.write(\"<style> .spots {display: none;} </style>\"";
NSString *what1 = @"var myElements = document.querySelectorAll(\".spots\"); for (var i = 0; i < myElements.length; i++) {myElements[i].style.display = none;}";

%hook CyteWebView
- (void)webView:(UIView *)view didFinishLoadForFrame:(id)arg2 {
	%orig;
	NSError *error;
NSString *css = [[NSString alloc] initWithContentsOfFile:@"/Library/Application Support/Intelliunborn/style.css" encoding:NSASCIIStringEncoding error:&error];
css = [css stringByReplacingOccurrencesOfString:@"\n" withString:@" "]; // js dom inject doesn't accept line breaks, so remove them

NSString *js = [NSString stringWithFormat:@"var styleNode = document.createElement('style');"
                "styleNode.type = 'text/css';"
                "styleNode.innerHTML = ' %@ ';", css];
js = [NSString stringWithFormat:@"%@document.getElementsByTagName('head')[0].appendChild(styleNode);", js];

[view stringByEvaluatingJavaScriptFromString:js];
}
- (void)reloadFromOrigin {
	%orig;
	NSError *error;
NSString *css = [[NSString alloc] initWithContentsOfFile:@"/Library/Application Support/Intelliunborn/style.css" encoding:NSASCIIStringEncoding error:&error];
css = [css stringByReplacingOccurrencesOfString:@"\n" withString:@" "]; // js dom inject doesn't accept line breaks, so remove them

NSString *js = [NSString stringWithFormat:@"var styleNode = document.createElement('style');"
                "styleNode.type = 'text/css';"
                "styleNode.innerHTML = ' %@ ';", css];
js = [NSString stringWithFormat:@"%@document.getElementsByTagName('head')[0].appendChild(styleNode);", js];

[self stringByEvaluatingJavaScriptFromString:js];
	NSLog(@"Help: %@", what1);
	////
}
- (id)request {
	%orig;
	NSError *error;
NSString *css = [[NSString alloc] initWithContentsOfFile:@"/Library/Application Support/Intelliunborn/style.css" encoding:NSASCIIStringEncoding error:&error];
css = [css stringByReplacingOccurrencesOfString:@"\n" withString:@" "]; // js dom inject doesn't accept line breaks, so remove them

NSString *js = [NSString stringWithFormat:@"var styleNode = document.createElement('style');"
                "styleNode.type = 'text/css';"
                "styleNode.innerHTML = ' %@ ';", css];
js = [NSString stringWithFormat:@"%@document.getElementsByTagName('head')[0].appendChild(styleNode);", js];

[self stringByEvaluatingJavaScriptFromString:js];
	return %orig;

}
%end

%hook HomeController
%new
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
NSError *error;
NSString *css = [[NSString alloc] initWithContentsOfFile:@"/Library/Application Support/Intelliunborn/style.css" encoding:NSASCIIStringEncoding error:&error];
css = [css stringByReplacingOccurrencesOfString:@"\n" withString:@" "]; // js dom inject doesn't accept line breaks, so remove them

NSString *js = [NSString stringWithFormat:@"var styleNode = document.createElement('style');"
                "styleNode.type = 'text/css';"
                "styleNode.innerHTML = ' %@ ';", css];
js = [NSString stringWithFormat:@"%@document.getElementsByTagName('head')[0].appendChild(styleNode);", js];

[self.view stringByEvaluatingJavaScriptFromString:js];
}
%end

