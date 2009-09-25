//
//  Song.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "Song.h"

@implementation Song

@synthesize numberOfUniqueNotes;
@synthesize name;

- (void) playNote:(Note *)note {
	NSLog(@"%@", note);
}

- (void) addNote:(Note *)newNote {
	// Is it a new unique note? If so, increment the number of unique notes
	bool unique = YES;
	for (Note *note in notes)
		if (newNote.pitch == note.pitch) {
			unique = NO;
			break;
		}
	if (unique)
		numberOfUniqueNotes ++;

	// Remember the note
	[notes addObject:newNote];		
}

- (id) init {
	return [self initWithContentsOfFile:nil];
}

- (id) initWithContentsOfFile:(NSString *)file {
	if (self = [super init]) {
		notes = [[NSMutableArray alloc] initWithCapacity:100];
		
		numberOfUniqueNotes = 0;
		
		if (nil == file) {
			[self addNote:[[Note alloc] initWithPitch:1 andDuration:1 at:0]];
			[self addNote:[[Note alloc] initWithPitch:2 andDuration:1 at:1]];
			[self addNote:[[Note alloc] initWithPitch:3 andDuration:1 at:2]];
			[self addNote:[[Note alloc] initWithPitch:4 andDuration:1 at:3]];
			[self addNote:[[Note alloc] initWithPitch:5 andDuration:1 at:4]];
			[self addNote:[[Note alloc] initWithPitch:1 andDuration:1 at:5.5]];
			[self addNote:[[Note alloc] initWithPitch:5 andDuration:1 at:5.5]];
			name = [[NSString alloc] initWithString:@"Test file"];
		} else {
			name = [file copy];
		}
	}
	return self;
}

- (void) dealloc {
	[nextNoteTimer invalidate];
	[nextNoteTimer release];
	[notes release];
	[name release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"[Song '%@' numNotes=%i uniqueNotes=%i]", name, notes.count, numberOfUniqueNotes];
}

- (NSArray *) getNextNotesAt:(NSTimeInterval)timestamp {
	// Go through the notes array and get the next one past the timestamp
	NSMutableArray *nextNotes = [[NSMutableArray alloc] initWithCapacity:10];

	for (Note *note in notes) {
		if (note.timestamp < timestamp)
			continue;
		else if (note.timestamp == timestamp)
			[nextNotes addObject:note];
		else
			break;
	}
	
	return nextNotes;
}

- (NSTimeInterval) getNextNoteTime:(Note *)note {
	int index = [notes indexOfObject:note];
	if (index != NSNotFound) {
		// Get the next note with a different timestamp
		Note *nextNote = note;
		while (nextNote.timestamp == note.timestamp) {
			index++;
			if (index < notes.count)
				nextNote = [notes objectAtIndex:index];
			else
				return 0;
		}
		
		return nextNote.timestamp;
	}
	
	return 0;
}

- (void) start {
	if (notes.count > 0) {
		currentPosition = 0;
		Note *firstNote = [notes objectAtIndex:0];
		nextNoteTimer = [[NSTimer scheduledTimerWithTimeInterval:firstNote.timestamp target:self selector:@selector(playNoteCallback:) userInfo:nil repeats:NO] retain];
	}
}

- (void) stop {
	[nextNoteTimer invalidate];
	[nextNoteTimer release];
	nextNoteTimer = nil;
}

- (void) playNoteCallback:(NSTimer *)timer {
	[nextNoteTimer release];
	nextNoteTimer = nil;
	
	NSArray *currentNotes = [self getNextNotesAt:currentPosition];
	
	if (0 != currentNotes.count) {
		for (Note *note in currentNotes)
			[self playNote:note];
		
		// Set the timer for the next note
		NSTimeInterval nextNoteTime = [self getNextNoteTime:[currentNotes objectAtIndex:0]];
		if (0 != nextNoteTime) {
			NSTimeInterval nextNoteInterval = nextNoteTime - currentPosition;
			currentPosition = nextNoteTime;
			nextNoteTimer = [[NSTimer scheduledTimerWithTimeInterval:nextNoteInterval target:self selector:@selector(playNoteCallback:) userInfo:nil repeats:NO] retain];
		}
	}
}

@end
