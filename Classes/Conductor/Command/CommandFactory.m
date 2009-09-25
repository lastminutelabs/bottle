//
//  CommandFactory.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "CommandFactory.h"
#import "PingCommand.h"

@implementation CommandFactory

+ (<Command>) commandWithData:(NSData *)data {
	<Command> command = nil;
	
	// Get the first 4 bytes from the data - this will be the type
	CommandType type;
	[data getBytes:&type length:sizeof(type)];
	switch (type) {
		case CommandTypePing:
			command = [[PingCommand alloc] init];
		break;
			
		case CommandTypePingResponse:
		default:
			NSLog(@"Unknown command type : %i", type);
	}
	
	return command;
}

@end
