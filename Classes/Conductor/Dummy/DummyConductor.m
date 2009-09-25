//
//  DummyConductor.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "DummyConductor.h"


@implementation DummyConductor

@synthesize delegate;
@synthesize name;

- (ConductorType) type { return ConductorTypeDummy; }

- (void) start { }
- (void) finish { }

@end
