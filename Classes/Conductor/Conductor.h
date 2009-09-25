//
//  Conductor.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ConductorTypeServer = 0,
	ConductorTypeClient
} ConductorType;

@protocol Conductor <NSObject>

@property (nonatomic, readonly) ConductorType type;

@end
