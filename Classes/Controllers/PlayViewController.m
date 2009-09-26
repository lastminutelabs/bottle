//
//  PlayViewController.m
//  Bottle
//
//  Created by Richard Lewis Jones on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "PlayViewController.h"
#import "UINoteView.h"

#define THRESHOLD 0.6f
#define BEATS_PER_SCREEN 8
#define GAP 0.25f

#define NUM_FILLINGS 8

#define NoteTolerence (0.25)

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

- (void) createNoteViews {
	
	// Remove the old notes
	for (UINoteView *noteView in noteViews)
		[noteView removeFromSuperview];
	[noteViews release];
	noteViews = [[NSMutableArray alloc] initWithCapacity:song.notes.count];
	
	for (Note *note in song.notes) {
		int h = (note.duration - GAP * song.secondsPerBeat) / secondsPerScreen * 480;
		int y = note.timestamp / secondsPerScreen * 480 + 480;
		
		UINoteView *view = [[UINoteView alloc] initWithFrame: CGRectMake(0, y, 320, h)];
		
		if ([note.pitch isEqualToString: pitch])
			view.backgroundColor = UIColor.lightGrayColor;
		else
			view.backgroundColor = UIColor.darkGrayColor;

		view.note = note;
		[noteViews addObject: view];
		[self.view addSubview:view];
	}
}

- (void) viewDidLoad {
  bottleImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bottle1.png"]];    
  [self.view addSubview: bottleImageView];         
}

- (void) setSong: (Song *) song_ andPitch: (NSString *) pitch_ {
	[ticker invalidate];
	[ticker release];
	ticker = nil;

	[song release];
	song = [song_ retain];

	[pitch release];
	pitch = [pitch_ copy];
	
	secondsPerScreen = BEATS_PER_SCREEN * song.secondsPerBeat;

	// Get the correct filling for the song
	float fillingsPerNote = NUM_FILLINGS / song.uniqueNotes.count;
	int index = fillingsPerNote * [song.uniqueNotes indexOfObject:pitch] + 1;
	bottleFillingView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"filling%i.png", index]]];  
	[self.view addSubview: bottleFillingView];
	
	// Initialize the correct pitch sound
	[self initializeSound];

	// Create the notes
	[self createNoteViews];

	// Sort out the view hierarchy
	[self.view bringSubviewToFront: bottleImageView];
	[self.view bringSubviewToFront: bottleFillingView];
	
	// Start at the beginning of the song
	songPosition = - secondsPerScreen;
}

- (void) startPlay {
	// Start the ticker to update the view
	ticker = [[NSTimer scheduledTimerWithTimeInterval:(1.0f/30.0f)
											   target:self
											 selector:@selector(tick:)
											 userInfo:nil
											  repeats:YES] retain];
}

- (void) detectAudio {
	// Get the amplitude from the mic
	Float32 power = [listener averagePower];
	player.volume = power;
	
	// Do we change note playing state?
	if (NO == currentlyPlaying) {
		if (power > THRESHOLD) {
			currentlyPlaying = YES;
		}
	} else {
		if (power < THRESHOLD) {
			currentlyPlaying = NO;
		}
	}
}

- (void) tick:(NSTimer *)timer {
	[self detectAudio];
	
	float sinceLastTime = [timer timeInterval];

	if (noteViews) {
		float offset = 480 * sinceLastTime / secondsPerScreen;

		for (UIView *noteView in noteViews)
			noteView.center = CGPointMake(noteView.center.x, noteView.center.y - offset);
	}
	
	// Remember where we are in the song and deal with any notes that we have missed
	songPosition += sinceLastTime;
	for (UINoteView *view in noteViews) {
		if (songPosition > view.note.timestamp + NoteTolerence) {
			[UIView beginAnimations:nil context:view];
			[UIView setAnimationDuration:0.35];
			[UIView setAnimationDidStopSelector:@selector(removeMissedNote:finished:context:)];
			view.center = CGPointMake(-500, view.center.y);
			view.alpha = 0.0f;
			[UIView commitAnimations];
		}
	}
}

- (void)removeMissedNote:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
	UINoteView *view = (UINoteView *)context;
	[view removeFromSuperview];
	[noteViews removeObject:view];
	[view release];
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
