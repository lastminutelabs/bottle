//
//  LobbyViewController.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conductor.h"
#import "Song.h"

@class LobbyViewController;

@protocol LobbyViewControllerDelegate <NSObject>

- (void) lobbyViewController:(LobbyViewController *)controller selectedSong:(Song *)song;

@end



@interface LobbyViewController : UIViewController {
	<LobbyViewControllerDelegate> delegate;
	<Conductor> conductor;
	NSArray *players;
	NSArray *songs;
	
	UITableView *songsTable;
	UITextView *playersView;
}

@property (nonatomic, retain) IBOutlet id delegate;
@property (nonatomic, retain) <Conductor> conductor;
@property (nonatomic, retain) IBOutlet UITableView *songsTable;
@property (nonatomic, retain) IBOutlet UITextView *playersView;

@property (nonatomic, retain) NSArray *players;
@property (nonatomic, retain) NSArray *songs;

@end
