//
//  StartOrJoinViewController.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conductor.h"

@class StartOrJoinViewController;

@protocol StartOrJoinViewControllerDelegate <NSObject>

- (void) controller:(StartOrJoinViewController *)controller createdConductor:(<Conductor>)conductor;

@end


@interface StartOrJoinViewController : UIViewController {
	<StartOrJoinViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet id delegate;

- (IBAction) join;
- (IBAction) practice;

@end
