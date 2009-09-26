//
//  SetSongCommand.m
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "SetSongCommand.h"


@implementation SetSongCommand

@synthesize name;
@synthesize pitch;

- (CommandType) type { return CommandTypeSetSong; }

- (NSString *) description {
	return [NSString stringWithFormat:@"[SetSongCommand '%@' at %@]", name, pitch];
}

@end
