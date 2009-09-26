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
