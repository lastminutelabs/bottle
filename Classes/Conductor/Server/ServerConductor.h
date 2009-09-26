//
//  ServerConductor.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conductor.h"
#import "PingCommand.h"
#import <GameKit/Gamekit.h>

#define PING_INTERVAL (1.0f)

@interface ServerConductor : NSObject <Conductor, GKSessionDelegate> {
	<ConductorDelegate> delegate;
	
	NSString *name;
	
	GKSession *session;
	
	NSMutableArray *peers;
	NSMutableArray *allPlayers;
	
	Song *song;
	
	NSTimer *pingTimer;
	
	bool readyToPlay;
}

@property (nonatomic, readonly) ConductorType type;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, retain) <ConductorDelegate> delegate;

@end
