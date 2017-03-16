#import <AudioToolbox/AudioToolbox.h>
%hook SBUIController
-(void)handleVolumeEvent:(id)arg1 {
	%orig;
	NSString *soundPath = @"/Library/Application Support/Tonus/Yosemite.aiff";
	SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    [soundPath release];
}
%end