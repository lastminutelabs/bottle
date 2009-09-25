//
//  ConductorFactory.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "ConductorFactory.h"
#import "ServerConductor.h"
#import "ClientConductor.h"

@implementation ConductorFactory

+ (<Conductor>) createConductor:(ConductorType)type {
	switch(type) {
		case ConductorTypeServer:
			return [[ServerConductor alloc] init];
		case ConductorTypeClient:
			return [[ClientConductor alloc] init];
		default:
			[NSException raise:@"Unknown Conductor type" format:@"Requested type was %i", type];
			return nil;
	}
}

@end
