//
//  BottleAppDelegate.m
//  Bottle
//
//  Created by Richard Lewis Jones on 25/09/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BottleAppDelegate.h"

@implementation BottleAppDelegate

@synthesize window;
@synthesize startOrJoinViewController;
@synthesize lobbyViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
	[window addSubview:startOrJoinViewController.view];
	
	debugView = [[UITextView alloc] initWithFrame:CGRectMake(10, window.frame.size.height-150, window.frame.size.width-20, 150)];
	debugView.alpha = 0.75;
	debugView.editable = NO;
	[window addSubview:debugView];
}

- (void)dealloc {
    [window release];
	[conductor release];
    [super dealloc];
}

- (void) controller:(StartOrJoinViewController *)controller createdConductor:(<Conductor>)conductor_ {
	[conductor release];
	conductor = [conductor_ retain];
	[conductor setDelegate:self];
	[conductor start];
	
	[startOrJoinViewController.view removeFromSuperview];
	lobbyViewController.conductor = conductor;
	[window insertSubview:lobbyViewController.view atIndex:0];
}


#pragma mark ---- ConductorDelegate methods ----

- (void) conductor:(<Conductor>)conductor hadError:(NSError *)error {
}

- (void) conductor:(<Conductor>)conductor hasDebugMessage:(NSString *)debugMessage {
	debugView.text = [NSString stringWithFormat:@"%@\n%@", debugView.text, debugMessage];
}

@end
