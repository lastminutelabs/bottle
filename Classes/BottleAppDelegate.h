//
//  BottleAppDelegate.h
//  Bottle
//
//  Created by Richard Lewis Jones on 25/09/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartOrJoinViewController.h"
#import "LobbyViewController.h"

@interface BottleAppDelegate : NSObject <UIApplicationDelegate, StartOrJoinViewControllerDelegate, ConductorDelegate> {
    UIWindow *window;
	UITextView *debugView;
	
	StartOrJoinViewController *startOrJoinViewController;
	LobbyViewController *lobbyViewController;
	
	<Conductor> conductor;
	
	NSMutableArray *songs;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet StartOrJoinViewController *startOrJoinViewController;
@property (nonatomic, retain) IBOutlet LobbyViewController *lobbyViewController;

@end
