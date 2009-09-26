//
//  DummyConductor.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "PracticeConductor.h"


@implementation PracticeConductor

@synthesize name;
@synthesize song;
@synthesize delegate;
@synthesize allPlayers;

- (void) debug:(NSString *)message {
	       if ([delegate respondsToSelector:@selector(conductor:hasDebugMessage:)])
		               [delegate conductor:self hasDebugMessage:message];
	       
	       NSLog(@"%@", message);
}

- (id) init {
	if (self = [super init]) {
		allPlayers = [[NSArray alloc] initWithObjects:@"Me", nil];
	}
	return self;
}

- (ConductorType) type { return ConductorTypePractice; }

- (void) start {
	[self debug:@"Practice session started"];
	[delegate conductor:self initializeSuccessful:YES];
	
	song = [delegate conductorRequestsAnySong:self];
	if (song) {
		[delegate conductor:self choseSong:song andPitch:[song.uniqueNotes lastObject]];
		[delegate conductorStartedPlay:self];
	}
}

- (void) finish { }

- (bool) readyToPlay { return YES; }
- (void) setReadyToPlay:(bool)value { }

@end
