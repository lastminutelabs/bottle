//
//  Command.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	CommandPing,
	CommandPingResponse
} CommandType;

@protocol Command <NSObject>

@property (nonatomic, readonly) CommandType type;

- (<Command>) initWithData:(NSData *)data;

- (NSData *) toData;

@end
