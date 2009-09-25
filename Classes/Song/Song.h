//
//  Song.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface Song : NSObject {
	NSMutableArray *notes;
	
	int numberOfUniqueNotes;
	
	NSTimer *nextNoteTimer;
	NSTimeInterval currentPosition;
	
	NSString *name;
	
	bool playing;
}

@property (nonatomic, readonly) int numberOfUniqueNotes;
@property (nonatomic, readonly) NSString *name;

- (id) initWithContentsOfFile:(NSString *)file;

- (void) start;
- (void) stop;

@end
