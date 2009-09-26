//
//  GraphicsOverlayViewController.h
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Command.h"
#import "GraphicsOverlayCommand.h"

@interface GraphicsOverlayViewController : UIViewController {

}

- (void) handleCommand:(GraphicsOverlayCommand *)command;

@end
