//
//  ServerConductor.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conductor.h"
#import <GameKit/Gamekit.h>

@interface ServerConductor : NSObject <Conductor, GKSessionDelegate> {
	NSString *name;
	
	GKSession *session;
}

@property (nonatomic, readonly) ConductorType type;
@property (nonatomic, readonly) NSString *name;

@end
