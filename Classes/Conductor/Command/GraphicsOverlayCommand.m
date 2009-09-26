//
//  GraphicsOverlayCommand.m
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "GraphicsOverlayCommand.h"


@implementation GraphicsOverlayCommand

@synthesize red, green, blue;
@synthesize duration;

- (CommandType) type { return CommandTypeGraphicsOverlay; }

@end
