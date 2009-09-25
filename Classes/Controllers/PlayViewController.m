//
//  PlayViewController.m
//  Bottle
//
//  Created by Richard Lewis Jones on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "PlayViewController.h"

#define THRESHOLD 0.6f

@implementation PlayViewController

- (id)init {
  if (self = [super init]) {    
    ticker = [[NSTimer scheduledTimerWithTimeInterval:(1.0f/30.0f)
		       target:self
		       selector:@selector(tick:)
		       userInfo:nil
		       repeats:YES] retain];

    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"bottle_loop" ofType: @"aif"];
    
    NSLog(@"soundFilePath: %@", soundFilePath);
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    [fileURL release];
    
    [player prepareToPlay];
    player.numberOfLoops = -1; // forever
    player.currentTime = 0;
    player.volume = 0.0;
    [player play];

    listener = [SCListener sharedListener];
    [listener listen];    
    
    playing = NO;
  }
  
  return self;
}

- (void) viewDidLoad {
  self.view = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];

  powerBar = [[UIProgressView alloc] initWithProgressViewStyle: UIProgressViewStyleDefault];
  powerBar.frame = CGRectMake(0, 200, 320, 100);
  [self.view addSubview: powerBar];

  powerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 100, 320, 100)];
  [self.view addSubview: powerLabel];

  playingLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 200, 320, 200)];
  [self.view addSubview: playingLabel];
}

- (void) startedPlaying {
  playingLabel.backgroundColor = UIColor.magentaColor;  
  // send an event to the server
}

- (void) stoppedPlaying {
  playingLabel.backgroundColor = UIColor.whiteColor;  
  // send an event to the server
}

- (void) tick:(NSTimer *)timer {
  Float32 power = [listener averagePower];
  powerBar.progress = power;
  player.volume = power;

  if (power > THRESHOLD && !playing) {
    playing = YES;
    [self startedPlaying];
  } else if (power < THRESHOLD && playing) {
    playing = NO;
    [self stoppedPlaying];
  }
  
  NSString *powerString = [NSString stringWithFormat: @"%.2f", power];
  powerLabel.text = powerString;
}

- (void)dealloc {
  [ticker invalidate];
  [ticker release];
  [super dealloc];
}

@end
