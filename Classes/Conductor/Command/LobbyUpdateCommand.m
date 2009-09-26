//
//  LobbyUpdateCommand.m
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "LobbyUpdateCommand.h"

@implementation LobbyUpdateCommand

@synthesize players;

- (CommandType) type { return CommandTypeLobbyUpdate; }

- (NSString *) description {
	return [NSString stringWithFormat:@"[LobbyUpdate numPlayers %i]", players.count];
}

@end
