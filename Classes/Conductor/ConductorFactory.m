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
#import "PracticeConductor.h"

@implementation ConductorFactory

+ (<Conductor>) conductorWithType:(ConductorType)type {
	<Conductor> conductor = nil;
	
	switch(type) {
		case ConductorTypeServer:
			conductor = [[[ServerConductor alloc] init] autorelease];
			break;
		case ConductorTypeClient:
			conductor = [[[ClientConductor alloc] init] autorelease];
			break;
		case ConductorTypePractice:
			conductor = [[[PracticeConductor alloc] init] autorelease];
			break;
		default:
			[NSException raise:@"Unknown Conductor type" format:@"Requested type was %i", type];
	}
	
	return conductor;
}

@end
