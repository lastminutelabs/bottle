//
//  LMClientPicker.h
//  Bottle
//
//  Created by Sam Dean on 01/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface LMClientPicker : UIViewController <GKSessionDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    BOOL visible;
    id<GKPeerPickerControllerDelegate> delegate;
    GKPeerPickerConnectionType connectionTypesMask;
    
    GKSession *session;
    
    NSMutableArray *clients;
    UITableView *clientTableView;
    
    UIView *fader;
    UIActivityIndicatorView *activityindicator;
}

@property (nonatomic, assign) GKPeerPickerConnectionType connectionTypesMask;

@property (nonatomic, assign) id<GKPeerPickerControllerDelegate> delegate;

@property (readonly, getter=isVisible) BOOL visible; 

- (void) show;
- (void) dismiss;

- (IBAction) cancel;
@property (nonatomic, retain) IBOutlet UITableView *clientTableView;

@end
