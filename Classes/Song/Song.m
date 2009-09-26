//
//  Song.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "Song.h"

@implementation Song

@synthesize name, secondsPerBeat;
@synthesize notes, uniqueNotes;

- (void) playNote:(Note *)note {
	NSLog(@"%@", note);
	[NSTimer scheduledTimerWithTimeInterval:note.duration target:self selector:@selector(endPlayingNoteCallback:) userInfo:note repeats:NO];
}

- (void) endPlayingNoteCallback:(NSTimer *)timer {
	if (playing) {
		Note *note = (Note *)timer.userInfo;
		NSLog(@"%@ finished", note);
	}
}

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
		playing = NO;
		
		if (nil == filename) {
			[self addNote:[[Note alloc] initWithPitch:@"1" andDuration:1 at:0]];
			[self addNote:[[Note alloc] initWithPitch:@"2" andDuration:1 at:1]];
			[self addNote:[[Note alloc] initWithPitch:@"1" andDuration:1 at:2]];
			[self addNote:[[Note alloc] initWithPitch:@"2" andDuration:1 at:3]];
			[self addNote:[[Note alloc] initWithPitch:@"1" andDuration:1 at:4]];
			[self addNote:[[Note alloc] initWithPitch:@"2" andDuration:1 at:5.5]];
			[self addNote:[[Note alloc] initWithPitch:@"1" andDuration:1 at:5.5]];
			name = [[NSString alloc] initWithString:@"Test file"];
		} else {
			// Open the file
			NSString *fileString = [NSString stringWithContentsOfFile:filename];
			if (nil == fileString)
				[NSException raise:@"Song failed to import" format:@"File at %@ failed to open", filename];
			
			NSArray *lines = [fileString componentsSeparatedByString:@"\n"];
			
			// The first two lines of the file are easy
			name = [[lines objectAtIndex:0] retain];
			secondsPerBeat = 60 / [[lines objectAtIndex:1] floatValue];
			
			// After that, each line is a note
			for (int n = 2; n < lines.count; ++n) {
				NSString *line = [lines objectAtIndex:n];
				NSScanner *scanner = [[NSScanner alloc] initWithString:line];
				float timestamp = -1;
				float duration = -1;
				NSString *pitch = nil;
				
				bool result = [scanner scanFloat:&timestamp];
				if (result)
					result = [scanner scanUpToString:@" " intoString:&pitch];
				if (result) 
					result = [scanner scanFloat:&duration];
				if (result) {
					Note *note = [[Note alloc] initWithPitch:pitch 
								   andDuration:duration * secondsPerBeat
								   at:(timestamp - 1) * secondsPerBeat];
					if (note)
						[self addNote:note];
					[note release];
				}
				[scanner release];
			}
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
	return [NSString stringWithFormat:@"[Song '%@' secondsPerBeat=%2.1f numNotes=%i uniqueNotes=%i]", name, secondsPerBeat, notes.count, uniqueNotes.count];
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
	if (! playing && notes.count > 0) {
		currentPosition = 0;
		playing = YES;
		Note *firstNote = [notes objectAtIndex:0];
		nextNoteTimer = [[NSTimer scheduledTimerWithTimeInterval:firstNote.timestamp target:self selector:@selector(playNoteCallback:) userInfo:nil repeats:NO] retain];
	}
}

- (void) stop {
	if (playing) {
		[nextNoteTimer invalidate];
		[nextNoteTimer release];
		nextNoteTimer = nil;
		playing = NO;
	}
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
