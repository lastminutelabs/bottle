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
#import "LobbyUpdateCommand.h"
#import "GraphicsOverlayCommand.h"

@implementation ServerConductor

@synthesize name;
@synthesize allPlayers;
@synthesize song;
@synthesize delegate;
@synthesize readyToPlay;

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
		readyToPlay = NO;
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

- (NSError *) sendCommand:(<Command>)command {
	NSData *data = [CommandCoder encodeCommand:command];
	NSError *error = nil;
	[session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:&error];
	
	if (nil != error)
		[self debug:[NSString stringWithFormat:@"Command failed to send : %@", [error localizedDescription]]];
	
	return error;
}

- (void) refreshLobby {
	LobbyUpdateCommand *update = [[LobbyUpdateCommand alloc] init];
	update.players = allPlayers;
	[self sendCommand:update];
	[update release];
}

- (void) triggerPing:(NSTimer *)timer {
	if (0 == peers.count)
		return;
	
	// Send a ping to everyone
	PingCommand *ping = [[PingCommand alloc] init];
	ping.timestamp = [NSDate date];
	[self sendCommand:ping];
	[ping release];
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
				[self refreshLobby];
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
				[self refreshLobby];
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
	
	int noteIndex = 0;
		
	// Give the peers the other notes
	SetSongCommand *command = [[SetSongCommand alloc] init];
	command.name = song.name;
	for (NSString *peerID in peers) {
		command.pitch = [song.uniqueNotes objectAtIndex:noteIndex];
		NSData *data = [CommandCoder encodeCommand:command];
		NSError *error = nil;
		[session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:&error];
		
		noteIndex ++;
		if (noteIndex >= song.uniqueNotes.count-1) // Save yourself the last note
			break;
	}
	[command release];
	
	// Tell the delegate that we have a song and pitch
	[delegate conductor:self choseSong:song andPitch:[song.uniqueNotes lastObject]];
	
	[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(testGraphics:) userInfo:nil repeats:NO];
}

- (void) testGraphics:(NSTimer *)timer {
	GraphicsOverlayCommand *command = [[GraphicsOverlayCommand alloc] init];
	command.red = 1.0;
	command.green = 0;
	command.blue = 0;
	command.duration = 1.0;
	[self sendCommand:command];
	[delegate conductor:self recievedUnknownCommand:command];
	[command release];
}

@end
