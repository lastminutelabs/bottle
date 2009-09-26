//
//  BottleAppDelegate.m
//  Bottle
//
//  Created by Richard Lewis Jones on 25/09/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BottleAppDelegate.h"
#import "Song.h"

@implementation BottleAppDelegate

@synthesize window;
@synthesize startOrJoinViewController;
@synthesize lobbyViewController;
@synthesize playViewController;

- (void) importSongs {
	[songs release];
	songs = [[NSMutableArray alloc] initWithCapacity:10];
	
	// Get all the songs in the path
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSFileManager *manager = [NSFileManager defaultManager];
	NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:path];
	NSString *file;
	while (file = [dirEnum nextObject])
		if ([file hasSuffix:@".btl"]) {
			@try {
				Song *song = [[Song alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", path, file]];
				[songs addObject:song];
				NSLog(@"Song loaded (on import) : %@", song);
			} @catch (NSException *e) {
				NSLog(@"Failed to import song (on import) : %@", e);
			}
		}
	
	// Add a test song
	Song *testSong = [[Song alloc] init];
	[songs addObject:testSong];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {   
	
	[self importSongs];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
	[window addSubview:startOrJoinViewController.view];
	
	debugView = [[UITextView alloc] initWithFrame:CGRectMake(10, window.frame.size.height-150, window.frame.size.width-20, 150)];
	debugView.alpha = 0.75;
	debugView.editable = NO;
	[window addSubview:debugView];
}

- (void)dealloc {
    [window release];
	[conductor release];
	[songs release];
    [super dealloc];
}

- (void) controller:(StartOrJoinViewController *)controller createdConductor:(<Conductor>)conductor_ {
	[conductor release];
	conductor = [conductor_ retain];
	[conductor setDelegate:self];
	[conductor start];
}


#pragma mark ---- ConductorDelegate methods ----

- (void) conductor:(<Conductor>)conductor hadError:(NSError *)error {
}

- (void) conductor:(<Conductor>)conductor hasDebugMessage:(NSString *)debugMessage {
	debugView.text = [NSString stringWithFormat:@"%@\n%@", debugView.text, debugMessage];
}

- (void) conductor:(<Conductor>)conductor_ initializeSuccessful:(bool)success {
	if (YES == success) {
		if (conductor_.type == ConductorTypePractice) {
			[startOrJoinViewController.view removeFromSuperview];
			[window insertSubview:playViewController.view atIndex:0];
		} else {
			[startOrJoinViewController.view removeFromSuperview];
			lobbyViewController.conductor = conductor;
			lobbyViewController.songs = songs;
			lobbyViewController.players = conductor_.allPlayers;
			[window insertSubview:lobbyViewController.view atIndex:0];
		}
	}
}

- (void) conductor:(<Conductor>)conductor_ addedPeer:(NSString *)displayName {
	lobbyViewController.players = conductor_.allPlayers;
}

- (void) conductor:(<Conductor>)conductor_ removedPeer:(NSString *)displayName {
	lobbyViewController.players = conductor_.allPlayers;
}

- (void) conductor:(<Conductor>)conductor_ choseSong:(Song *)song andPitch:(NSString *)pitch {
	NSLog(@"Pitch set to %@", pitch);
	
	// Change to the play view
	[lobbyViewController.view removeFromSuperview];
	[window addSubview:playViewController.view];
}

- (Song *) conductor:(<Conductor>)conductor requestsSongWithName:(NSString *)songName {
	for (Song *song in songs) {
		if ([song.name isEqual:songName])
			return song;
	}
	
	return nil;
}

#pragma mark ---- LobbyViewController ----

- (void) lobbyViewController:(LobbyViewController *)controller selectedSong:(Song *)song {
	// Store the song in the conductor
	conductor.song = song;
}

@end
