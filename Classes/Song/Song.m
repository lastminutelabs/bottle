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
	}
	return self;
}

@end
