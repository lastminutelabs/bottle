//
//  ConductorFactory.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conductor.h"

@interface ConductorFactory : NSObject

+ (<Conductor>) conductorWithType:(ConductorType)type;

@end
