//
//  PingCommand.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "PingCommand.h"


@implementation PingCommand

@synthesize timestamp;

- (CommandType) type { return CommandTypePing; }

- (void) dealloc {
	[timestamp release];
	[super dealloc];
}

- (NSString *) description {
	return [NSString stringWithFormat:@"[Ping %@]", timestamp];
}

@end
