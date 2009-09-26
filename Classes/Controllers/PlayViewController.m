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
  NSLog(@"VIEW DID LOAD");

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
    
  self.view = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
  self.view.backgroundColor = UIColor.blackColor;

  bottleImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bottle1.png"]];    
  [self.view addSubview: bottleImageView];    

  bottleFillingView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"filling1.png"]];    
  [self.view addSubview: bottleFillingView];      

  noteViews = nil;
}

- (void) setSong: (Song *) song_ andPitch: (NSString *) pitch_ {
  NSLog(@"Setting song: %@ and pitch: %@", song_, pitch_);

  [song release];
  [pitch release];
  song = [song_ retain];
  pitch = [pitch_ retain];

  if (noteViews) {
    for (UIView *noteView in noteViews) {
      [noteView removeFromSuperview];    
    }
  }

  [noteViews release];
  noteViews = [PlayViewController noteViewsForSong: song andPitch: pitch];

  for (UIView *note in noteViews) {
    [self.view addSubview: note];    
  }

  [self.view bringSubviewToFront: bottleImageView];

  // TODO: base this graphic on the pitch
  [self.view bringSubviewToFront: bottleFillingView];
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
  player.volume = power;

  if (noteViews) {

    float sinceLastTime = [timer timeInterval];
    
    // TODO: shouldn't need to keep recalculating this
    float secondsPerBeat = song.secondsPerBeat;
    float beatsPerSecond = 1.0f / secondsPerBeat;
    float secondsPerScreen = BEATS_PER_SCREEN / beatsPerSecond;
    
    float offset = 480 * sinceLastTime / secondsPerScreen;
    
    for (UIView *noteView in noteViews) {
      noteView.center = CGPointMake(noteView.center.x, noteView.center.y - offset);
    }
  }
}

- (void)dealloc {
  [ticker invalidate];
  [ticker release];
  [super dealloc];
}

@end
