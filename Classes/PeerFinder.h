//
//  PeerFinder.h
//  BluetoothTest
//
//  Created by Sam Dean on 02/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GameKit/GameKit.h>

@class PeerFinder;


@protocol PeerFinderDelegate <NSObject>

- (void) controller:(PeerFinder *)finder hasSession:(GKSession *)session;

@end


@interface PeerFinder : UITableViewController <GKSessionDelegate> {
    
    NSMutableArray *possibles;
    
    GKSession *session;
    
    <PeerFinderDelegate> delegate;
}

@property (nonatomic, retain) <PeerFinderDelegate> delegate;

@end
