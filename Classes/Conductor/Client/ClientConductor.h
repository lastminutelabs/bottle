//
//  ClientConductor.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conductor.h"

@interface ClientConductor : NSObject <Conductor> {
	<ConductorDelegate> delegate;
}

@property (nonatomic, readonly) ConductorType type;
@property (nonatomic, retain) <ConductorDelegate> delegate;

@end
