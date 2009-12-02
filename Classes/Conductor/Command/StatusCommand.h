//
//  StatusCommand.h
//  Bottle
//
//  Created by Richard Lewis Jones on 02/12/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"
#import "Status.h"

@interface StatusCommand : NSObject <Command> {
	StatusType status;
}

@property (nonatomic, assign) StatusType status;

@end
