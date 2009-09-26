//
//  PlayViewController.m
//  Bottle
//
//  Created by Richard Lewis Jones on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "PlayViewController.h"

#define THRESHOLD 0.6f

#define BEATS_PER_SCREEN 8

#define GAP 0.25f

@implementation PlayViewController

- (void) viewDidLoad {
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
	
  self.view = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];

  powerBar = [[UIProgressView alloc] initWithProgressViewStyle: UIProgressViewStyleDefault];
  powerBar.frame = CGRectMake(0, 200, 320, 100);
  [self.view addSubview: powerBar];

  powerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 100, 320, 100)];
  [self.view addSubview: powerLabel];

  playingLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 200, 320, 200)];
  [self.view addSubview: playingLabel];
  
  NSString *path = [[NSBundle mainBundle] bundlePath];
  @try {
    song = [[Song alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Jingle Bells.btl", path]];
    NSLog(@"Song loaded : %@", song);
  } @catch (NSException *e) {
    NSLog(@"Failed to import song : %@", e);
  }

  NSArray *noteViews = [PlayViewController noteViewsForSong: song andPitch: @"e4"];

  for (UIView *noteView in noteViews) {
    [self.view addSubview: noteView];    
  }
}

- (void) startedPlaying {
  playingLabel.backgroundColor = UIColor.magentaColor;  
  // send an event to the server
}

- (void) stoppedPlaying {
  playingLabel.backgroundColor = UIColor.whiteColor;  
  // send an event to the server
}

+ (NSArray *) noteViewsForSong: (Song *) song andPitch: (NSString *) pitch {
  // returns an array of UIView objects of the right size and offset for the given Song

  NSArray *notes = song.notes;  
  NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity: notes.count];

  float secondsPerBeat = song.secondsPerBeat;
  float beatsPerSecond = 1.0f / secondsPerBeat;
  float secondsPerScreen = BEATS_PER_SCREEN / beatsPerSecond;

  for (Note *note in notes) {
    int h = (note.duration - GAP * secondsPerBeat) / secondsPerScreen * 480;
    int y = note.timestamp / secondsPerScreen * 480;

    UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, y, 320, h)];

    if ([note.pitch isEqualToString: pitch]) {
      view.backgroundColor = UIColor.lightGrayColor;
    } else {
      view.backgroundColor = UIColor.darkGrayColor;
    }
    
    [views addObject: view];
  }
  
  return views;
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
