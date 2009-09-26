//
//  SetSongCommand.h
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface SetSongCommand : NSObject <Command> {
	NSString *name;
	NSString *pitch;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pitch;

@end
