//
//  GraphicsOverlayCommand.h
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface GraphicsOverlayCommand : NSObject <Command> {
	double red;
	double green;
	double blue;
	NSTimeInterval duration;
}

@property (nonatomic, assign) double red;
@property (nonatomic, assign) double green;
@property (nonatomic, assign) double blue;
@property (nonatomic, assign) NSTimeInterval duration;

@end
