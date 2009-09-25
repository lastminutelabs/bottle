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
@synthesize delegate;

- (ConductorType) type { return ConductorTypeServer; }

- (NSString *)description {
	return [NSString stringWithFormat:@"[ServerConductor \"%@\"]", name];
}

- (id) init {
	if (self = [super init]) {
		// Create our name
		name = [[NSString stringWithFormat:@"%@ server", [[UIDevice currentDevice] name]] retain];
	}
	return self;
}

- (void) start {
	// If we're in a session already, finish it
	[self finish];
	
	// Create the bluetooth server session
	session = [[GKSession alloc] initWithSessionID:@"your mom" displayName:name sessionMode:GKSessionModeServer];
	[session setDelegate:self];
	[session setDataReceiveHandler:self withContext:nil];
	[session setAvailable:YES];
}

- (void) finish {
	[session disconnectFromAllPeers];
	[session setAvailable:NO];
	[session setDelegate:nil];
	[session release];
	session = nil;
}

- (void) dealloc {
	[self finish];
	[delegate release];
	[name release];
	[super dealloc];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession: (GKSession *)session_ context:(void *)context {
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state { }
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID { }

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	[delegate conductor:self hadError:error];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	[delegate conductor:self hadError:error];
}

@end
