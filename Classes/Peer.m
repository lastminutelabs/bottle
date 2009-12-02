//
//  Peer.m
//  BluetoothTest
//
//  Created by Sam Dean on 02/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Peer.h"


@implementation Peer

@synthesize peerID, displayName, state;

- (void) dealloc {
    [peerID release];
    [displayName release];
    [super dealloc];
}

@end
