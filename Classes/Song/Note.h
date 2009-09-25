//
//  Note.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Note : NSObject {
	int duration;
	int pitch;
	NSTimeInterval timestamp;
}

@property (nonatomic, readonly) int pitch;
@property (nonatomic, readonly) int duration;
@property (nonatomic, readonly) NSTimeInterval timestamp;

- (id) initWithPitch:(int)pitch andDuration:(int)duration at:(NSTimeInterval)timestamp;

@end
