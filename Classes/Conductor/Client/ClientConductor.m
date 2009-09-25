//
//  ClientConductor.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "ClientConductor.h"

@implementation ClientConductor

@synthesize delegate;
@synthesize name;

- (void) debug:(NSString *)message {
	if ([delegate respondsToSelector:@selector(conductor:hasDebugMessage:)])
		[delegate conductor:self hasDebugMessage:message];
	
	NSLog(@"%@", message);
}

- (id) init {
	if (self = [super init]) {
		name = [[NSString stringWithFormat:@"%@ client", [[UIDevice currentDevice] name]] retain];
	}
	return self;
}

- (void) dealloc {
	[delegate release];
	[name release];
	[super dealloc];
}

- (ConductorType) type { return ConductorTypeClient; }

- (NSString *)description {
	return [NSString stringWithFormat:@"[ClientConductor name=\"%@\"]", name];
}

- (void) start {
	// If we're in a session already, finish it
	[self finish];
	
	// Create the picker to get a session
	GKPeerPickerController *controller = [[GKPeerPickerController alloc] init];
	[controller setDelegate:self];
	[controller setConnectionTypesMask:GKPeerPickerConnectionTypeNearby];
	[controller show];
	[controller release];
}

- (void) finish {
	[session disconnectFromAllPeers];
	[session setAvailable:NO];
	[session setDelegate:nil];
	[session release];
	session = nil;
}

#pragma mark ---- PeerPickerDelegate methods ----

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
	return [[GKSession alloc] initWithSessionID:GAME_ID displayName:name sessionMode:GKSessionModePeer];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session_ {
	// Keep the session and release the picker
	session = [session_ retain];
	[picker dismiss];
}

@end
