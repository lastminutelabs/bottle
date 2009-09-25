//
//  Song.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "Song.h"


@implementation Song

- (id) init {
	return [self initWithContentsOfFile:nil];
}

- (id) initWithContentsOfFile:(NSString *)file {
	if (self = [super init]) {
		notes = [[NSMutableArray alloc] initWithCapacity:100];
		
		[notes addObject:[[Note alloc] initWithPitch:1 andDuration:1000 at:0000]];
		[notes addObject:[[Note alloc] initWithPitch:2 andDuration:1000 at:1000]];
		[notes addObject:[[Note alloc] initWithPitch:3 andDuration:1000 at:2000]];
		[notes addObject:[[Note alloc] initWithPitch:4 andDuration:1000 at:3000]];
		[notes addObject:[[Note alloc] initWithPitch:5 andDuration:1000 at:4000]];
	}
	return self;
}

- (void) dealloc {
	[notes release];
	[super dealloc];
}

@end
