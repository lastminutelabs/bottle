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

#define NUM_FILLINGS 8

@implementation PlayViewController

- (NSError *) initializeSound {
	[player stop];
	[player release];
	
	NSError *error = nil;
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:pitch ofType: @"aif"];    
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: &error];
	[fileURL release];
	if (error)
		NSLog(@"Failed to load pitch %@ : %@", pitch, error);
	else {
		[player prepareToPlay];
		player.numberOfLoops = -1; // forever
		player.currentTime = 0;
		player.volume = 0.0;
		[player play];
	}
	
	[listener stop];
	[listener release];
	listener = [SCListener sharedListener];
	[listener listen];
	
	return error;
}

- (void) viewDidLoad {
  self.view = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
  self.view.backgroundColor = UIColor.blackColor;

  bottleImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bottle1.png"]];    
  [self.view addSubview: bottleImageView];         

  noteViews = nil;
}

- (void) setSong: (Song *) song_ andPitch: (NSString *) pitch_ {
	[ticker invalidate];
	[ticker release];
	ticker = nil;
	
	NSLog(@"Setting song: %@ and pitch: %@", song_, pitch_);

	[song release];
	song = [song_ retain];

	[pitch release];
	pitch = [pitch_ copy];
	
	// Get the correct filling for the song
	float fillingsPerNote = NUM_FILLINGS / song.uniqueNotes.count;
	int index = fillingsPerNote * [song.uniqueNotes indexOfObject:pitch] + 1;
	bottleFillingView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"filling%i.png", index]]];  
	[self.view addSubview: bottleFillingView]; 
	
	// Initialize the correct pitch sound
	[self initializeSound];

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
    int y = note.timestamp / secondsPerScreen * 480 + 480;

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

- (void) startPlay {
	// Start the ticker to update the view
	ticker = [[NSTimer scheduledTimerWithTimeInterval:(1.0f/30.0f)
											   target:self
											 selector:@selector(tick:)
											 userInfo:nil
											  repeats:YES] retain];
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

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown 
	  || interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
  [ticker invalidate];
  [ticker release];
  [super dealloc];
}

@end
