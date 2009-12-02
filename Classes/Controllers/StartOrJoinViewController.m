//
//  StartOrJoinViewController.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "StartOrJoinViewController.h"
#import "ConductorFactory.h"
#import "PeerFinder.h"

@implementation StartOrJoinViewController

@synthesize delegate;

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[delegate release];
    [super dealloc];
}

- (IBAction) join {
	//[delegate controller:self createdConductor:[ConductorFactory conductorWithType:ConductorTypeServer]];
//    [delegate controller:self 
    
    // Push a peer connection view
    PeerFinder *controller = [[PeerFinder alloc] initWithNibName:@"PeerFinder" bundle:nil];
    [controller viewWillAppear:NO];
    [self.view addSubview:controller.view];
    [controller viewDidAppear:NO];
}

- (IBAction) practice {
	[delegate controller:self createdConductor:[ConductorFactory conductorWithType:ConductorTypePractice]];
}

@end
