//
//  StatusCommand.m
//  Bottle
//
//  Created by Richard Lewis Jones on 02/12/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "StatusCommand.h"


@implementation StatusCommand

@synthesize status;

- (CommandType) type { return CommandTypeStatus; }

@end
