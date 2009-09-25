//
//  DummyConductor.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "PracticeConductor.h"


@implementation PracticeConductor

@synthesize delegate;
@synthesize name;

- (void) debug:(NSString *)message {
	if ([delegate respondsToSelector:@selector(conductor:hasDebugMessage:)])
		[delegate conductor:self hasDebugMessage:message];
	
	NSLog(@"%@", message);
}

- (ConductorType) type { return ConductorTypeDummy; }

- (void) start {
	[self debug:@"Practice session started"];
	[delegate conductor:self initializeSuccessful:YES];
}

- (void) finish { }

@end
