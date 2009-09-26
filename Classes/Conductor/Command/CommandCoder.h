//
//  CommandFactory.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface CommandCoder : NSObject

+ (<Command>) commandWithData:(NSData *)data;
+ (NSData *) encodeCommand:(<Command>)command;

@end
