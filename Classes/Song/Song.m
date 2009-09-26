//
//  Song.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "Song.h"

NSInteger sortNotes(id a, id b, void *data) {
	if ([a isEqual: b]) return NSOrderedSame;
	
	// Get the second char of each one
	NSString *a2 = [a substringFromIndex:1];
	NSString *b2 = [b substringFromIndex:1];
	if ([b2 intValue] > [a2 intValue])
		return NSOrderedAscending;
	else if ([b2 intValue] < [a2 intValue])
		return NSOrderedDescending;
	else
		return [a compare:b];
}


@implementation Song

@synthesize name, secondsPerBeat;
@synthesize notes, uniqueNotes;
@synthesize duration;

- (void) addNote:(Note *)newNote {
	// Is it a new unique note? If so, increment the number of unique notes
	bool unique = YES;
	for (Note *note in notes)
		if ([newNote.pitch isEqual:note.pitch]) {
			unique = NO;
			break;
		}
	if (unique)
		[uniqueNotes addObject:newNote.pitch];

	// Remember the note
	[notes addObject:newNote];		
}

- (id) init {
	return [self initWithContentsOfFile:nil];
}

- (id) initWithContentsOfFile:(NSString *)filename {
	if (self = [super init]) {
		notes = [[NSMutableArray alloc] initWithCapacity:100];
		
		uniqueNotes = [[NSMutableArray alloc] initWithCapacity:10];
		
		if (nil == filename) 
			[NSException raise:@"Can't deal with nil as a file name" format:@""];
			
		// Open the file
		NSString *fileString = [NSString stringWithContentsOfFile:filename];
		if (nil == fileString)
			[NSException raise:@"Song failed to import" format:@"File at %@ failed to open", filename];
		
		NSArray *lines = [fileString componentsSeparatedByString:@"\n"];
		
		// We need to store the duration of the song
		duration = 0;
		
		// The first two lines of the file are easy
		name = [[lines objectAtIndex:0] retain];
		secondsPerBeat = 60 / [[lines objectAtIndex:1] floatValue];
		
		// After that, each line is a note
		for (int n = 2; n < lines.count; ++n) {
			NSString *line = [lines objectAtIndex:n];
			NSScanner *scanner = [[NSScanner alloc] initWithString:line];
			float timestamp = -1;
			float noteDuration = -1;
			NSString *pitch = nil;
			
			bool result = [scanner scanFloat:&timestamp];
			if (result)
				result = [scanner scanUpToString:@" " intoString:&pitch];
			if (result) 
				result = [scanner scanFloat:&noteDuration];
			if (result) {
				Note *note = [[Note alloc] initWithPitch:pitch 
							   andDuration:noteDuration * secondsPerBeat
							   at:(timestamp - 1) * secondsPerBeat];
				if (note) {
					[self addNote:note];
					if (note.timestamp + note.duration > duration)
						duration = note.timestamp + note.duration;
				}
				[note release];
			}
			[scanner release];
		}
		
		// Make sure the unique notes are in the right order
		[uniqueNotes sortUsingFunction:sortNotes context:nil];
	}
	return self;
}

- (void) dealloc {
	[notes release];
	[name release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"[Song '%@' secondsPerBeat=%2.1f numNotes=%i uniqueNotes=%i]", name, secondsPerBeat, notes.count, uniqueNotes.count];
}

@end
