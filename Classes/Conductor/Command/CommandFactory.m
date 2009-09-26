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
	int dataOffset = sizeof(type);
	switch (type) {
		case CommandTypePing: {
			command = [[PingCommand alloc] init];
			NSTimeInterval interval;
			[data getBytes:&interval range:NSMakeRange(dataOffset, sizeof(interval))];
			[(PingCommand *)command setTimestamp:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:interval]];
		}
		break;
			
		case CommandTypePingResponse:
		default:
			NSLog(@"Trying to decode unknown <Command> type : %i", type);
	}
	
	return command;
}

+ (NSData *)encodeCommand:(<Command>)command {
	NSMutableData *data = [[[NSMutableData alloc] initWithCapacity:10] autorelease];
	
	switch (command.type) {
		case CommandTypePing: {
			PingCommand *ping = (PingCommand *)command;
			CommandType type = ping.type;
			NSTimeInterval interval = [ping.timestamp timeIntervalSinceReferenceDate];
			[data appendBytes:&type length:sizeof(type)];
			[data appendBytes:&interval length:sizeof(interval)];
		}
		break;
			
		default:
			NSLog(@"Trying to encode unknonwn <Command> type %i", command.type);
			break;
	}
	
	return data;
}

@end
