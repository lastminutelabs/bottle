//
//  PlayViewController.h
//  Bottle
//
//  Created by Richard Lewis Jones on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SCListener.h"
#import "Song.h"

@interface PlayViewController : UIViewController {  
  NSTimer *ticker;
  NSMutableArray *noteViews;
  UIImageView *bottleImageView;
  UIImageView *bottleFillingView;
  SCListener *listener;
  AVAudioPlayer *player;
  Song *song;
  NSString *pitch;
  NSMutableArray *bottleImages;
  NSTimeInterval songPosition;
  float secondsPerScreen;
  
  bool currentlyPlaying;
	float score;
}

- (void) setSong: (Song *) song andPitch: (NSString *) pitch;

- (void) startPlay;

@end
