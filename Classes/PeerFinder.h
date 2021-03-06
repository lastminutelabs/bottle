//
//  PeerFinder.h
//  BluetoothTest
//
//  Created by Sam Dean on 02/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GameKit/GameKit.h>

#import "Peer.h"

@class PeerFinder;


@protocol PeerFinderDelegate <NSObject>

- (void) peerFinder:(PeerFinder *)finder isServerWithSession:(GKSession *)session;
- (void) peerFinder:(PeerFinder *)finder isClientWithSession:(GKSession *)session forServer:(NSString *)serverPeerID;

@end


@interface PeerFinder : UITableViewController <GKSessionDelegate> {
    
    NSMutableArray *possibles;
    
    GKSession *session;
    
    <PeerFinderDelegate> delegate;
    
    UIButton *conductButton;
    
    IBOutlet UILabel *youAreLabel;
    IBOutlet UILabel *connectedToLabel;
    
    Peer *connectingTo;
}

@property (nonatomic, retain) <PeerFinderDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIButton *conductButton;

@property (nonatomic, retain) IBOutlet UILabel *youAreLabel;
@property (nonatomic, retain) IBOutlet UILabel *connectedToLabel;

- (IBAction) conduct;

@end
