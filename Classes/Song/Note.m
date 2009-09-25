//
//  Note.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "Note.h"


@implementation Note

@synthesize pitch, duration;

- (id) init {
	return [self initWithPitch:0 andDuration:0];
}

- (id) initWithPitch:(int)pitch_ andDuration:(int)duration_ {
	if (self = [super init]) {
		pitch = pitch_;
		duration = duration_;
	}
	return self;
}

@end
