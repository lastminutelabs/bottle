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

@interface PlayViewController : UIViewController {  
  NSTimer *ticker;
  UILabel *powerLabel;
  UILabel *playingLabel;
  UIProgressView *powerBar;
  SCListener *listener;
  AVAudioPlayer *player;
  BOOL playing;
}

@end
