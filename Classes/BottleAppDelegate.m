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
    [super dealloc];
}

@end
