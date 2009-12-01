//
//  ClientConductor.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "ClientConductor.h"
#import "CommandCoder.h"
#import "SetSongCommand.h"
#import "LobbyUpdateCommand.h"
#import "StartPlayCommand.h"

@implementation ClientConductor

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

- (id) init {
	if (self = [super init]) {
		name = [[NSString stringWithFormat:@"%@ client", [[UIDevice currentDevice] name]] retain];
		readyToPlay = NO;
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

- (NSError *) sendCommandToServer:(<Command>)command {
	NSData *data = [CommandCoder encodeCommand:command];
	NSError *error = nil;
	[session sendData:data toPeers:[NSArray arrayWithObject:serverPeerID] withDataMode:GKSendDataReliable error:&error];
	
	if (nil != error)
		[self debug:[NSString stringWithFormat:@"Command failed to send : %@", [error localizedDescription]]];
	
	return error;
}

- (void) start {
	// If we're in a session already, finish it
	[self finish];
	
	// Create the picker to get a session
	GKPeerPickerController *controller = [[GKPeerPickerController alloc] init];
	[controller setDelegate:self];
	[controller setConnectionTypesMask:GKPeerPickerConnectionTypeNearby];
	[controller show];
	[self debug:@"Client picker started"];
}

- (void) finish {
	[session disconnectFromAllPeers];
	[session setAvailable:NO];
	[session setDelegate:nil];
	[session setDataReceiveHandler:nil withContext:nil];
	[session release];
	session = nil;
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession: (GKSession *)session_ context:(void *)context {
	// Create the command from the data
	<Command> command = [CommandCoder commandWithData:data];
	switch (command.type) {
		case CommandTypePing:
			break;
			
		case CommandTypeSetSong:
			[self debug:[command description]];
			
			// Get the song from the delegate
			Song *newSong = [delegate conductor:self requestsSongWithName:[(SetSongCommand*)command name]];
			if (newSong) {
				[song release];
				song = [newSong retain];
				[delegate conductor:self choseSong:song andPitch:[(SetSongCommand *)command pitch]];
			}
			break;
			
		case CommandTypeLobbyUpdate:
			[self debug:[command description]];
			[delegate conductor:self changedPlayersTo:[(LobbyUpdateCommand *)command players]];
			break;
			
		case CommandTypeStartPlay:
			[delegate conductorStartedPlay:self];
			break;
		
		default:
			[delegate conductor:self recievedUnknownCommand:command];
			break;
	}
}

#pragma mark ---- PeerPickerDelegate methods ----

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
	return [[[GKSession alloc] initWithSessionID:GAME_ID displayName:name sessionMode:GKSessionModePeer] autorelease];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session_ {
	// Keep the session and release the picker
	[session release];
	session = [session_ retain];
	[session setDataReceiveHandler:self withContext:nil];
	[serverPeerID release];
	serverPeerID = [peerID copy];
	[picker dismiss];
	[picker release];
	[delegate conductor:self initializeSuccessful:YES];
	
	[self debug:[session peerID]];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
	[delegate conductor:self initializeSuccessful:NO];
}

- (void) setSong:(Song *)value {
	[NSException raise:@"Clients cannot set the song!" format:@""];
}

- (void) setReadyToPlay:(bool)value {
	readyToPlay = value;
	
	if (YES == value) {
		StartPlayCommand *command = [[StartPlayCommand alloc] init];
		[self sendCommandToServer:command];
		[command release];
	}
}

@end
