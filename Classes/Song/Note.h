//
//  Note.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Note : NSObject {
	NSTimeInterval duration;
	NSString *pitch;
	NSTimeInterval timestamp;
}

@property (nonatomic, readonly) NSString * pitch;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) NSTimeInterval timestamp;

- (id) initWithPitch:(NSString *)pitch andDuration:(NSTimeInterval)duration at:(NSTimeInterval)timestamp;

@end
