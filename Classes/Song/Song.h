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
	
	NSMutableArray *uniqueNotes;
	
	float secondsPerBeat;
	
	NSString *name;
}

@property (nonatomic, readonly) NSArray *uniqueNotes;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) float secondsPerBeat;
@property (nonatomic, readonly) NSArray *notes;

- (id) initWithContentsOfFile:(NSString *)filename;

@end
