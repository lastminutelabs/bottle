//
//  ServerConductor.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "ServerConductor.h"
#import "CommandCoder.h"
#import "SetSongCommand.h"

@implementation ServerConductor

@synthesize name;
@synthesize allPlayers;
@synthesize song;
@synthesize delegate;

- (void) debug:(NSString *)message {
	if ([delegate respondsToSelector:@selector(conductor:hasDebugMessage:)])
		[delegate conductor:self hasDebugMessage:message];
	
	NSLog(@"%@", message);
}

- (ConductorType) type { return ConductorTypeServer; }

- (NSString *)description {
	return [NSString stringWithFormat:@"[ServerConductor \"%@\"]", name];
}

- (id) init {
	if (self = [super init]) {
		name = [[NSString stringWithFormat:@"%@ server", [[UIDevice currentDevice] name]] retain];
	}
	return self;
}

- (void) start {
	// If we're in a session already, finish it
	[self finish];
	
	// Create the bluetooth server session
	session = [[GKSession alloc] initWithSessionID:GAME_ID displayName:name sessionMode:GKSessionModePeer];
	[session setDelegate:self];
	[session setDataReceiveHandler:self withContext:nil];
	[session setAvailable:YES];
	
	// Create the peers array
	peers = [[NSMutableArray alloc] initWithCapacity:10];
	allPlayers = [[NSMutableArray alloc] initWithCapacity:10];
	[allPlayers addObject:[session displayName]];
	
	[self debug:@"Server session started"];
	
	[delegate conductor:self initializeSuccessful:YES];
	
	pingTimer = [[NSTimer scheduledTimerWithTimeInterval:PING_INTERVAL target:self selector:@selector(triggerPing:) userInfo:nil repeats:YES] retain];
}

- (void) finish {
	[pingTimer invalidate];
	[pingTimer release];
	pingTimer = nil;
	[session disconnectFromAllPeers];
	[session setAvailable:NO];
	[session setDelegate:nil];
	[session release];
	session = nil;
	[peers release];
	peers = nil;
	[allPlayers release];
	allPlayers = nil;
}

- (void) dealloc {
	[self finish];
	[delegate release];
	[name release];
	[super dealloc];
}

- (void) triggerPing:(NSTimer *)timer {
	if (0 == peers.count)
		return;
	
	// Send a ping to everyone
	PingCommand *ping = [[PingCommand alloc] init];
	ping.timestamp = [NSDate date];
	NSData *data = [CommandCoder encodeCommand:ping];
	NSError *error = nil;
	[session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:&error];
	[ping release];
	
	if (nil != error)
		[self debug:[NSString stringWithFormat:@"Ping failed to send : %@", [error localizedDescription]]];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession: (GKSession *)session_ context:(void *)context {
}

- (void)session:(GKSession *)session_ peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	
	NSString *displayName = [session_ displayNameForPeer:peerID];

	switch (state) {
		// If we know about these peers, remove them in these states
		case GKPeerStateUnavailable:
		case GKPeerStateDisconnected:
			if ([peers containsObject:peerID]) {
				[peers removeObject:peerID];
				[allPlayers removeObject:displayName];
				[delegate conductor:self removedPeer:displayName];
				[self debug:[NSString stringWithFormat:@"peer %@ removed", displayName]];
			} else {
				[self debug:[NSString stringWithFormat:@"peer %@ already removed!", displayName]];
			}
			break;
			
		case GKPeerStateConnected:
			if (![peers containsObject:peerID]) {
				[peers addObject:peerID];
				[allPlayers addObject:displayName];
				[delegate conductor:self addedPeer:displayName];
				[self debug:[NSString stringWithFormat:@"peer %@ connected", displayName]];
			} else {
				[self debug:[NSString stringWithFormat:@"peer %@ already connected!", displayName]];
			}
			break;
			
		case GKPeerStateAvailable:
		case GKPeerStateConnecting:
			break;

		default:
			[self debug:[NSString stringWithFormat:@"%@ reported unknown state : %i", displayName, state]];
		}
}

- (void)session:(GKSession *)session_ didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	NSError *error = nil;
	[session_ acceptConnectionFromPeer:peerID error:&error];
	[self debug:[NSString stringWithFormat:@"Accept connection from %@", [session displayNameForPeer:peerID]]];
}

- (void)session:(GKSession *)session_ connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	[delegate conductor:self hadError:error];
}

- (void)session:(GKSession *)session_ didFailWithError:(NSError *)error {
	[delegate conductor:self hadError:error];
}

- (void) setSong:(Song *)value {
	[song release];
	song = [value retain];
	
	SetSongCommand *command = [[SetSongCommand alloc] init];
	command.name = song.name;
	NSData *data = [CommandCoder encodeCommand:command];
	NSError *error = nil;
	[session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:&error];
	[command release];
}

@end
