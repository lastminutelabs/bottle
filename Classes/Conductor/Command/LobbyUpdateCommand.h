//
//  LobbyUpdateCommand.h
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface LobbyUpdateCommand : NSObject <Command> {
	NSArray *players;
}

@property (nonatomic, retain) NSArray *players;

@end
