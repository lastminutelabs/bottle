//
//  BottleAppDelegate.h
//  Bottle
//
//  Created by Richard Lewis Jones on 25/09/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartOrJoinViewController.h"
#import "PlayViewController.h"

@interface BottleAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  
  StartOrJoinViewController *startOrJoinViewController;
  PlayViewController *playViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet StartOrJoinViewController *startOrJoinViewController;
@property (nonatomic, retain) PlayViewController *playViewController;

@end
