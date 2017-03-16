#import <substrate.h>

//#include "InspCWrapper.m"

NSArray *moreSupportedLanguages()
{
	return @[
				@"en-SG", // English for Singapore
				@"pt-BR", // Portuguese for Brazil
				@"da-DK", // Danish
				@"nl-NL", // Dutch
				@"en-NZ", // English for New Zealand
				@"en-IN", // English for India
				@"ru-RU", // Russian
				@"sv-SE", // Swedish
				@"th-TH", // Thai
				@"tr-TR", // Turkish
				
				// as of iOS 9
				@"nb-NO", // Norwegian (Bokmål) (Norway)
				@"de-AT", // German for Austria
				@"fr-BE", // French for Belgium
				@"nl-BE" // Dutch for Belgium
	];
}

NSArray *(*PSSupportedLanguages)();
NSArray *(*original_PSSupportedLanguages)();
NSArray *hax_PSSupportedLanguages()
{
	NSMutableArray *array = [NSMutableArray array];
	[array addObjectsFromArray:original_PSSupportedLanguages()];
	for (NSString *language in moreSupportedLanguages()) {
		if (![array containsObject:language])
			[array addObject:language];
	}
	return array;
}

NSArray *(*PSSupportedLanguages2)(void *);
NSArray *(*original_PSSupportedLanguages2)(void *);
NSArray *hax_PSSupportedLanguages2(void *block)
{
	NSMutableArray *array = [NSMutableArray array];
	[array addObjectsFromArray:original_PSSupportedLanguages2(block)];
	for (NSString *language in moreSupportedLanguages()) {
		if (![array containsObject:language])
			[array addObject:language];
	}
	return array;
}

%group VoiceTrigger

%hook VTPreferences

- (NSString *)localizedTriggerPhraseForLanguageCode:(NSString *)languageCode
{
	if ([languageCode isEqualToString:@"th-TH"])
		return @"หวัดดี Siri";
	if ([languageCode isEqualToString:@"da-DK"])
		return @"Hej Siri";
	if ([languageCode isEqualToString:@"nb-NO"])
		return @"Hei Siri";
	if ([languageCode isEqualToString:@"en-US"])
		return @"Hey Jarvis";
	/*if ([languageCode isEqualToString:@"nl-NL"])
		return @"??? Siri";*/
	/*if ([languageCode isEqualToString:@"pt-BR"])
		return @"??? Siri";*/
	/*if ([languageCode isEqualToString:@"ru-RU"])
		return @"??? Siri";*/
	/*if ([languageCode isEqualToString:@"sv-SE"])
		return @"??? Siri";*/
	/*if ([languageCode isEqualToString:@"tr-TR"])
		return @"??? Siri";*/
	return %orig;
}

%end

%end
%hook VTPhraseSpotter
- (id)analyze:(id)arg1 {
	%orig;
	NSArray *array = [NSArray arrayWithObjects: [NSString stringWithFormat:@"Hey Jarvis"], nil];
	MSHookIvar<NSArray*>(self,"_triggerPhrases") = array;
	NSLog(@"Result: %@", %orig);
	return %orig;
}
%end

%ctor
{
	%init;
	const char *ASSISTANT = "/System/Library/PrivateFrameworks/AssistantServices.framework/AssistantServices";
	const char *VT = "/System/Library/PrivateFrameworks/VoiceTrigger.framework/VoiceTrigger";
	if (![NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.voicetrigger.voicetriggerservice"]) {
		void *assistant = dlopen(ASSISTANT, RTLD_LAZY);
		if (assistant != NULL) {
			MSImageRef ref = MSGetImageByName(ASSISTANT);
			const char *function = "__AFPreferencesBuiltInLanguages";
			PSSupportedLanguages = (NSArray *(*)())MSFindSymbol(ref, function);
			MSHookFunction((void *)PSSupportedLanguages, (void *)hax_PSSupportedLanguages, (void **)&original_PSSupportedLanguages);
			if (kCFCoreFoundationVersionNumber >= 1129.15) {
				const char *function2 = "____AFPreferencesBuiltInLanguages_block_invoke";
				PSSupportedLanguages2 = (NSArray *(*)(void *))MSFindSymbol(ref, function2);
				MSHookFunction((void *)PSSupportedLanguages2, (void *)hax_PSSupportedLanguages2, (void **)&original_PSSupportedLanguages2);
				void *trigger = dlopen(VT, RTLD_LAZY);
				if (trigger != NULL) {
					%init(VoiceTrigger);
				}
			}
		}
	} else {
		//%init(VoiceTrigger);
	}
}