//
//  GraphicsOverlayViewController.m
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "GraphicsOverlayViewController.h"

@implementation GraphicsOverlayViewController

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
    [super dealloc];
}

- (void) handleCommand:(GraphicsOverlayCommand *)command {
	// Create the view that we need
	UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
	view.backgroundColor = [UIColor colorWithRed:command.red green:command.green blue:command.blue alpha:1.0];
	view.alpha = 1.0f;
	[self.view addSubview:view];
    [view release];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:command.duration];
	view.alpha = 0.0f;
	[UIView commitAnimations];
}

@end
