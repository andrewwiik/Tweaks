%new
-(void)performAction:(int)arg1 {
if (arg1 == 1) [SharedTitlesView nowPlayingNextAction]; // Next Song (Now Playing)
else if(arg1 == 2) [SharedTitlesView nowPlayingPreviousAction]; // Previous Song Now Playing
else if(arg1 == 3) [MusicSharedRemote handleTapOnControlType:5]; // Now Playing 15 Seconds Forward
else if(arg1 == 4) [MusicSharedRemote handleTapOnControlType:2]; // Now Playing 15 Seconds Back
else if(arg1 == 5) [MusicSharedRemote handleTapOnControlType:6]; // Now Playing Like/Heart Song
else if(arg1 == 6) [MusicSharedRemote handleTapOnControlType:7]; // Now Playing Present Up Next
else if(arg1 == 7) [MusicSharedRemote handleTapOnControlType:10]; // Now Playing Set Shuffling
else if(arg1 == 8) [MusicSharedRemote handleTapOnControlType:9]; // Now Playing Set Repeating
else if(arg1 == 9) [MusicSharedRemote handleTapOnControlType:8]; // Now Playing Show Context Menu
else if(arg1 == 10) [MusicSharedRemote handleTapOnControlType:8]; // 
else if(arg1 == 11) [MusicSharedRemote handleTapOnControlType:4]; // Next Song
else if(arg1 == 12) [MusicSharedRemote handleTapOnControlType:4]; // Next Song
else if(arg1 == 13) [MusicSharedRemote handleTapOnControlType:4]; // Next Song
else if(arg1 == 14) [MusicSharedRemote handleTapOnControlType:4]; // Next Song
else if(arg1 == 15) [MusicSharedRemote handleTapOnControlType:4]; // Next Song
else if(arg1 == 16) [MusicSharedRemote handleTapOnControlType:4]; // Next Song
else if(arg1 == 17) [MusicSharedRemote handleTapOnControlType:4]; // Next Song
else if(arg1 == 18) [MusicSharedRemote handleTapOnControlType:4]; // Next Song
else if(arg1 == 19) [MusicSharedRemote handleTapOnControlType:4]; // Next Song
}
%end


switch (arg1) {
	case NowPlayingMusicApp: {
		switch (arg2) { // Next Song ~ Now Playing : Music App
			case 1: {
				CGRect frame = SharedTitlesView.frame;
		     	[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * -1, SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height); } completion:^(BOOL finished){
		        	[MusicSharedRemote handleTapOnControlType:4];
					SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * 1 ,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height);
					[UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = frame; } completion:^(BOOL finished){}];}];
		     	break;
		 	}
			case 2: { // Previous Song ~ Now Playing : Music App
				CGRect frame = SharedTitlesView.frame;
		     	[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * 1,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height); } completion:^(BOOL finished){
		        	[MusicSharedRemote handleTapOnControlType:1];
					SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * -1 ,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height);
					[UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = frame; } completion:^(BOOL finished){}];}];  
				break;
			}
			case 3: { // 15 seconds forward : Universal
				[MusicSharedRemote handleTapOnControlType:5];
					break;
			}
			case 4: { // 15 seconds rewind : Universal
				[MusicSharedRemote handleTapOnControlType:2];
					break;
			}
			case 5: { // like/Heart Song : Universal
				[MusicSharedRemote handleTapOnControlType:6];
					break;
			}
			case 6: { // Present Up Next ~ Now Playing : Music App
				[MusicSharedRemote handleTapOnControlType:7];
					break;
			}
			case 7: { // Set Shuffling : Universal
				[MusicSharedRemote handleTapOnControlType:10];
					break;
			}
			case 8: { // Set Repeating : Universal
				[MusicSharedRemote handleTapOnControlType:9];
					break;
			}
			case 9: { // Show Context Menu ~ Now Playing : Music App
				[MusicSharedRemote handleTapOnControlType:8];
					break;
			}
			case 10: { // Play/Pause Toggle : Universal
				[MusicSharedRemote handleTapOnControlType:3];
					break;
			}
		}
	}
}

			<array>
				<string>Not Set</string>
				<string>Next Song</string>
				<string>Previous Song</string>
				<string>Play/Pause</string>
				<string>15 Seconds Forward</string>
				<string>15 Seconds Back</string>
				<string>Like/Heart Song</string>
				<string>Present Up Next</string>
				<string>Set Shuffling</string>
				<string>Set Repeating</string>
				<string>Show Context Menu</string>
			</array>
			<key>validValues</key>
			<array>
				<integer>99</integer>
				<integer>1</integer>
				<integer>2</integer>
				<integer>10</integer>
				<integer>3</integer>
				<integer>4</integer>
				<integer>5</integer>
				<integer>6</integer>
				<integer>7</integer>
				<integer>8</integer>
				<integer>9</integer>
			</array>


    if ([arg1 isEqual: @"NowPlayingMusicApp"]) {
        switch (arg2) { // Next Song ~ Now Playing : Music App
                case 1: {
                    CGRect frame = SharedTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * -1, SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height); } completion:^(BOOL finished){
                        [MusicSharedRemote handleTapOnControlType:4];
                        SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * 1 ,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = frame; } completion:^(BOOL finished){}];}];
                    break;
                }

                case 2: { // Previous Song ~ Now Playing : Music App
                    CGRect frame = SharedTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * 1,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height); } completion:^(BOOL finished){
                        [MusicSharedRemote handleTapOnControlType:1];
                        SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * -1 ,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = frame; } completion:^(BOOL finished){}];}];  
                    break;
                }

                case 3: { // 15 seconds forward : Universal
                    [MusicSharedRemote handleTapOnControlType:5];
                        break;
                }

                case 4: { // 15 seconds rewind : Universal
                    [MusicSharedRemote handleTapOnControlType:2];
                        break;
                }

                case 5: { // like/Heart Song : Universal
                    [MusicSharedRemote handleTapOnControlType:6];
                        break;
                }

                case 6: { // Present Up Next ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:7];
                        break;
                }

                case 7: { // Set Shuffling : Universal
                    [MusicSharedRemote handleTapOnControlType:10];
                        break;
                }

                case 8: { // Set Repeating : Universal
                    [MusicSharedRemote handleTapOnControlType:9];
                        break;
                }

                case 9: { // Show Context Menu ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:8];
                        break;
                }

                case 10: { // Play/Pause Toggle : Universal
                    [MusicSharedRemote handleTapOnControlType:3];
                        break;
                }
            }
        }
        if ([arg1 isEqual: @"MiniPlayerMusicApp"]) {
        switch (arg2) { // Next Song ~ Now Playing : Music App
                case 1: {
                    CGRect frame = SharedTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * -1, SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height); } completion:^(BOOL finished){
                        [MusicSharedRemote handleTapOnControlType:4];
                        [UIView animateWithDuration:.5 animations:^{nowplayingitem.imgView.frame = CGRectMake(nowplayingitem.frame.size.height /6,nowplayingitem.view.frame.size.height /6,nowpalyingitem.view.frame.size.height /1.5,nowplayingitem.view.frame.size.height/1.5);}];
                        SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * 1 ,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = frame; } completion:^(BOOL finished){}];}];
                    break;
                }

                case 2: { // Previous Song ~ Now Playing : Music App
                    CGRect frame = SharedTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * 1,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height); } completion:^(BOOL finished){
                        [MusicSharedRemote handleTapOnControlType:1];
                        SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * -1 ,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = frame; } completion:^(BOOL finished){}];}];  
                    break;
                }

                case 3: { // 15 seconds forward : Universal
                    [MusicSharedRemote handleTapOnControlType:5];
                        break;
                }

                case 4: { // 15 seconds rewind : Universal
                    [MusicSharedRemote handleTapOnControlType:2];
                        break;
                }

                case 5: { // like/Heart Song : Universal
                    [MusicSharedRemote handleTapOnControlType:6];
                        break;
                }

                case 6: { // Present Up Next ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:7];
                        break;
                }

                case 7: { // Set Shuffling : Universal
                    [MusicSharedRemote handleTapOnControlType:10];
                        break;
                }

                case 8: { // Set Repeating : Universal
                    [MusicSharedRemote handleTapOnControlType:9];
                        break;
                }

                case 9: { // Show Context Menu ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:8];
                        break;
                }

                case 10: { // Play/Pause Toggle : Universal
                    [MusicSharedRemote handleTapOnControlType:3];
                        break;
                }
            }
        }
    	else {
        	return;
        }
	}