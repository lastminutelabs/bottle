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
#import "PlayViewController.h"
#import "GraphicsOverlayViewController.h"

@interface BottleAppDelegate : NSObject <UIApplicationDelegate, StartOrJoinViewControllerDelegate, ConductorDelegate, LobbyViewControllerDelegate> {
    UIWindow *window;
	UITextView *debugView;
	
	StartOrJoinViewController *startOrJoinViewController;
	LobbyViewController *lobbyViewController;
	PlayViewController *playViewController;
	GraphicsOverlayViewController *graphicsOverlayViewController;
	
	<Conductor> conductor;
	
	NSMutableArray *songs;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet StartOrJoinViewController *startOrJoinViewController;
@property (nonatomic, retain) IBOutlet LobbyViewController *lobbyViewController;
@property (nonatomic, retain) IBOutlet PlayViewController *playViewController;
@property (nonatomic, retain) IBOutlet GraphicsOverlayViewController *graphicsOverlayViewController;

@end
