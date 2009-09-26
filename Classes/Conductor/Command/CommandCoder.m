//
//  CommandFactory.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "CommandCoder.h"
#import "PingCommand.h"
#import "SetSongCommand.h"

@implementation CommandCoder

+ (<Command>) commandWithData:(NSData *)data {
	<Command> command = nil;
	
	NSString *error = nil;
	NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
	NSDictionary *props = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:0 format:&format errorDescription:&error];
	
	NSNumber *type = [props objectForKey:@"type"];
	switch ([type intValue]) {
		case CommandTypePing: {
			command = [[PingCommand alloc] init];
			NSNumber *interval = [props objectForKey:@"interval"];
			[(PingCommand *)command setTimestamp:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[interval doubleValue]]];
		}
		break;

		case CommandTypeSetSong: {
			command = [[SetSongCommand alloc] init];
			[(SetSongCommand *)command setName:[props objectForKey:@"name"]];
		}
		break;

		default:
			NSLog(@"Trying to decode unknown <Command> type : %i", type);
	}
	
	return command;
}

+ (NSData *)encodeCommand:(<Command>)command {
	NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
	[props setValue:[NSNumber numberWithInt:command.type] forKey:@"type"];
	
	switch (command.type) {
		case CommandTypePing: {
			PingCommand *ping = (PingCommand *)command;
			NSTimeInterval interval = [ping.timestamp timeIntervalSinceReferenceDate];
			[props setValue:[NSNumber numberWithDouble:interval] forKey:@"interval"];
		}
		break;
			
		case CommandTypeSetSong: {
			SetSongCommand *setSong = (SetSongCommand *)command;
			[props setValue:setSong.name forKey:@"name"];
		}
		break;
			
		default:
			NSLog(@"Trying to encode unknonwn <Command> type %i", command.type);
			break;
	}

	NSString *error = nil;
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:props format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
	return data;
}

@end
