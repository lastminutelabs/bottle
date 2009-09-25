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

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
	[window addSubview:startOrJoinViewController.view];
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
	NSLog(@"Conductor created : %@", conductor);
	
	[conductor start];
}


#pragma mark ---- ConductorDelegate methods ----

- (void) conductor:(<Conductor>)conductor hadError:(NSError *)error {
}

@end
