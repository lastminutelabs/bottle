//
//  ServerConductor.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "ServerConductor.h"


@implementation ServerConductor

@synthesize name;

- (ConductorType) type { return ConductorTypeServer; }

- (NSString *)description {
	return [NSString stringWithFormat:@"[ServerConductor %@]", name];
}

- (id) init {
	if (self = [super init]) {
		// Create our name
		name = [NSString stringWithFormat:@"%@ server", [[UIDevice currentDevice] name]];
		
		// Create the bluetooth session
		session = [[GKSession alloc] initWithSessionID:@"your mom" displayName:name sessionMode:GKSessionModeServer];
		[session setDelegate:self];
		[session setDataReceiveHandler:self withContext:nil];
		[session setAvailable:YES];
	}
	return self;
}

- (void) dealloc {
	[session disconnectFromAllPeers];
	[session setAvailable:NO];
	[session setDelegate:nil];
	[session release];	
	[super dealloc];
}

@end
