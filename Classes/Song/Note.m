//
//  Note.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "Note.h"


@implementation Note

@synthesize pitch, duration, timestamp;

- (id) init {
	return [self initWithPitch:0 andDuration:0 at:0];
}

- (id) initWithPitch:(NSString *)pitch_ andDuration:(NSTimeInterval)duration_ at:(NSTimeInterval)timestamp_ {
	if (self = [super init]) {
		pitch = [pitch_ copy];
		duration = duration_;
		timestamp = timestamp_;
	}
	return self;
}

- (void) dealloc {
	[pitch release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"[Note pitch:%@ duration:%f at:%f]", pitch, duration, timestamp];
}

- (BOOL) isEqual:(Note *)note {
	return [self.pitch isEqual:note.pitch] && self.duration == note.duration && self.timestamp == note.timestamp;
}

@end
