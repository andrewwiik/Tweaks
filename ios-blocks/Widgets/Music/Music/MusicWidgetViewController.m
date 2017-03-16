//
//  MusicWidgetViewController.m
//  Music
//
//  Created by Matt Clarke on 04/11/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MusicWidgetViewController.h"
#import <SpringBoard7.0/SBMediaController.h>
#import "IBKMusicButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import <objc/runtime.h>

typedef void (^MRMediaRemoteGetNowPlayingInfoCompletion)(CFDictionaryRef information);
void MRMediaRemoteGetNowPlayingInfo(dispatch_queue_t queue, MRMediaRemoteGetNowPlayingInfoCompletion completion);

@interface SBMediaController (iOS8)
-(NSString*)ibkNowPlayingArtist;
-(NSString*)ibkNowPlayingAlbum;
-(NSString*)ibkNowPlayingTitle;
-(UIImage*)ibkArtwork;
-(BOOL)ibkTrackSupports15SecondFF;
-(BOOL)ibkTrackSupports15SecondRewind;
@end

@interface IBKResources : NSObject

+(CGFloat)widthForWidget;

@end

static UIImage *cachedMosaic;

#define IOS8_or_higher ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define path @"/var/mobile/Library/Curago/Widgets/com.apple.Music/"

@implementation MusicWidgetViewController

-(UIImage*)mosaicImageOfAlbumArtwork {
    MPMediaQuery *query = [MPMediaQuery albumsQuery];
    NSMutableArray *allAlbums = [[query collections] mutableCopy];
    
    if (allAlbums.count < 16) {
        return nil;
    }
    
    // Begin rendering. 4x4 for self.view's frame.
    
    CGFloat widthHeight = self.view.frame.size.width/4;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, self.view.frame.size.width), YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    int column = 0;
    
    for (int row = 0; row < 4; row++) {
        while (column < 4) {
            int index = arc4random() % (int)allAlbums.count;
            
            MPMediaItem *item = [allAlbums[index] representativeItem];
            MPMediaItemArtwork *image = [item valueForProperty:MPMediaItemPropertyArtwork];
            UIImage *img = [image imageWithSize:CGSizeMake(widthHeight, widthHeight)];
            
            [img drawInRect:CGRectMake(column*widthHeight, row*widthHeight, widthHeight, widthHeight)];
            
            [allAlbums removeObjectAtIndex:index]; // No duplicates
            
            column++;
        }
        
        column = 0;
    }
    
    // pop context
    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (self.view == nil) {
        self.isPad = isIpad;
        
		self.view = [[UIView alloc] initWithFrame:frame];
		self.view.backgroundColor = [UIColor clearColor];

		// Alright! If we're iPad, then render text too, else, just artwork.
        
        UIImage *mosaic = [self mosaicImageOfAlbumArtwork];
        cachedMosaic = mosaic;
        
        if (!mosaic) {
            self.noMediaPlaying = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [objc_getClass("IBKResources") widthForWidget]-40, (isIpad ? 207 : 118)-(isIpad ? 50 : 30))];
            self.noMediaPlaying.numberOfLines = 0;
            self.noMediaPlaying.text = @"No media playing";
            self.noMediaPlaying.textAlignment = NSTextAlignmentCenter;
            self.noMediaPlaying.textColor = [UIColor whiteColor];
            if (isIpad) {
                self.noMediaPlaying.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
            } else {
                self.noMediaPlaying.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            }
            self.noMediaPlaying.backgroundColor = [UIColor clearColor];
        
            [self.view addSubview:self.noMediaPlaying];
        }
        
        // generate mosaic image for self.artwork
        
        // Artwork.
        
        self.artwork = [[UIImageView alloc] initWithFrame:frame];
        self.artwork.backgroundColor = [UIColor clearColor];
        self.artwork.contentMode = UIViewContentModeScaleAspectFill;
        self.artwork.image = mosaic;
        self.artwork.alpha = 0.5;
        
        [self.view addSubview:self.artwork];
        
        if (isIpad) {
            // Title and artist.
            
            // TODO.
        }
        
        // Notifications.
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveUpdateToMusicData:) name:@"IBK-UpdateMusic" object:nil];
        
        // And if playing, update!
        
        if ([(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying]) {
            [self didReceiveUpdateToMusicData:nil];
            
            self.artwork.alpha = 1.0;
            self.noMediaPlaying.alpha = 0.0;
        }
	}

	return self.view;
}

-(void)didReceiveUpdateToMusicData:(id)sender {
    // I'd imagine we can pull data from SpringBoard now.
    NSLog(@"*** [Curago | com.apple.music] :: Pulling new data");
    
    if (IOS8_or_higher) {
        // Deal with that shit.
        [self delayed8update];
    } else {
        self.artwork.image = [UIImage imageWithData:[(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] _nowPlayingInfo] [@"artworkData"]];
        self.songtitle.text = [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] nowPlayingTitle];
        self.artist.text = [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] nowPlayingArtist];
        
        // Update control buttons state.
        [self setPlayButtonState:[(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying]];
        
        if (![(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying] && ![(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] _nowPlayingInfo] [@"artworkData"]) {
            self.noMediaPlaying.alpha = 1.0;
            
            if (cachedMosaic) {
                self.artwork.image = cachedMosaic;
                self.artwork.alpha = 0.5;
            }
        } else {
            self.noMediaPlaying.alpha = 0.0;
            self.artwork.alpha = 1.0;
        }
    }
}

-(void)delayed8update {
    UIImage __block *artwork;
    BOOL __block isPlaying;
    
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        artwork = [UIImage imageWithData:[(__bridge NSDictionary*)information objectForKey:@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
        
        self.songtitle.text = [(__bridge NSDictionary*)information objectForKey:@"kMRMediaRemoteNowPlayingInfoArtist"];
        self.artist.text = [(__bridge NSDictionary*)information objectForKey:@"kMRMediaRemoteNowPlayingInfoAlbum"];
        self.artwork.image = artwork;
        isPlaying = [[(__bridge NSDictionary*)information objectForKey:@"kMRMediaRemoteNowPlayingInfoPlaybackRate"] boolValue];
        
        // Update control buttons state.
        [self setPlayButtonState:isPlaying];
        
        if (!isPlaying && !artwork) {
            self.noMediaPlaying.alpha = 1.0;
            
            if (cachedMosaic) {
                self.artwork.image = cachedMosaic;
                self.artwork.alpha = 0.5;
            }
        } else {
            self.noMediaPlaying.alpha = 0.0;
            self.artwork.alpha = 1.0;
        }
    });
}

-(void)setPlayButtonState:(BOOL)state {
    if (state) {
        self.play.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Pause%@", path, [self suffix]]];
    } else {
        self.play.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Play%@", path, [self suffix]]];
    }
}

-(BOOL)hasButtonArea {
    return YES;
}

-(BOOL)hasAlternativeIconView {
    return NO;
}

-(BOOL)wantsGradientBackground {
    return YES;
}

-(NSArray*)gradientBackgroundColors {
    return [NSArray arrayWithObjects:@"FF2C58", @"FF5939", nil];
}

-(UIView*)buttonAreaViewWithFrame:(CGRect)frame {
    UIView *buttons = [[UIView alloc] initWithFrame:frame];
    buttons.backgroundColor = [UIColor clearColor];
    
    self.forward = [IBKMusicButton buttonWithType:UIButtonTypeCustom];
    self.forward.frame = CGRectMake(frame.size.width-25, (frame.size.height/2)-10, 20, 20);
    self.forward.backgroundColor = [UIColor clearColor];
    self.forward.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Forward%@", path, [self suffix]]];
    [self.forward addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttons addSubview:self.forward];
    
    self.play = [IBKMusicButton buttonWithType:UIButtonTypeCustom];
    self.play.frame = CGRectMake(frame.size.width-50, (frame.size.height/2)-10, 20, 20);
    self.play.backgroundColor = [UIColor clearColor];
    self.play.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Play%@", path, [self suffix]]];
    [self.play addTarget:self action:@selector(playPause:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttons addSubview:self.play];
    
    self.rewind = [IBKMusicButton buttonWithType:UIButtonTypeCustom];
    self.rewind.frame = CGRectMake(frame.size.width-75, (frame.size.height/2)-10, 20, 20);
    self.rewind.backgroundColor = [UIColor clearColor];
    self.rewind.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Rewind%@", path, [self suffix]]];
    [self.rewind addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttons addSubview:self.rewind];
    
    [self setPlayButtonState:[(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying]];
    
    return buttons;
}

-(NSString*)suffix {
    NSString *suffix = @"";
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale >= 2.0 && scale < 3.0) {
        suffix = [suffix stringByAppendingString:@"@2x.png"];
    } else if (scale >= 3.0) {
        suffix = [suffix stringByAppendingString:@"@3x.png"];
    } else if (scale < 2.0) {
        suffix = [suffix stringByAppendingString:@".png"];
    }
    
    return suffix;
}

-(void)forward:(id)sender {
    [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] changeTrack:1];
}

-(void)back:(id)sender {
    [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] changeTrack:-1];
}

-(void)playPause:(id)sender {
    if ([(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying]) {
        [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] pause];
    } else {
        [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] play];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.artwork removeFromSuperview];
    self.artwork = nil;
    
    [self.songtitle removeFromSuperview];
    self.songtitle = nil;
    
    [self.artist removeFromSuperview];
    self.artist = nil;
}

@end