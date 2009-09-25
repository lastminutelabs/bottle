//
//  LobbyViewController.m
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "LobbyViewController.h"
#import "Song.h"

@implementation LobbyViewController

@synthesize conductor;
@synthesize players;
@synthesize songs, songsTable;

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) viewDidLoad {
	if (conductor)
		songsTable.userInteractionEnabled = conductor.type == ConductorTypeServer;
}

- (void)dealloc {
	[conductor release];
    [super dealloc];
}

- (void) setSongs:(NSArray *)value {
	[songs release];
	songs = [value retain];
	[songsTable reloadData];
}

- (void) setPlayers:(NSArray *)value {
	[players release];
	players = [value retain];
	[songsTable reloadData];
}

- (void) setConductor:(<Conductor>)value {
	[conductor release];
	conductor = [value retain];
	songsTable.allowsSelection = conductor.type == ConductorTypeServer;
	[songsTable reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SongCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Song *song = [songs objectAtIndex:indexPath.row];
    cell.textLabel.text = [song name];
	int diff = song.numberOfUniqueNotes - players.count;
	cell.detailTextLabel.text = diff <= 0 ? @"available" : [NSString stringWithFormat:@"%i more player(s) needed", diff];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
