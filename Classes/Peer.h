//
//  Peer.h
//  BluetoothTest
//
//  Created by Sam Dean on 02/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

@interface Peer : NSObject {
    NSString *peerID;
    NSString *displayName;
    GKPeerConnectionState state;
}

@property (copy) NSString *peerID;
@property (copy) NSString *displayName;
@property (assign) GKPeerConnectionState state; 

@end
