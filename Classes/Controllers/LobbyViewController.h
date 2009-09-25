//
//  LobbyViewController.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conductor.h"

@interface LobbyViewController : UIViewController {
	<Conductor> conductor;
}

@property (nonatomic, retain) <Conductor> conductor;

@end
