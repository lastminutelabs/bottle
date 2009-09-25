//
//  ServerConductor.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "ServerConductor.h"


@implementation ServerConductor

- (ConductorType) type { return ConductorTypeServer; }

- (NSString *)description {
	return [NSString stringWithFormat:@"[ServerConductor]"];
}

@end
