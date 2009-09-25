//
//  Conductor.h
//  Bottle
//
//  Created by Sam Dean on 25/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GAME_ID @"Bottle"

typedef enum {
	ConductorTypeServer = 0,
	ConductorTypeClient
} ConductorType;

@protocol Conductor;

@protocol ConductorDelegate <NSObject>

- (void) conductor:(<Conductor>)conductor hadError:(NSError *)error;

@end



@protocol Conductor <NSObject>

@property (nonatomic, readonly) ConductorType type;
@property (nonatomic, readonly) NSString *name;

@property (nonatomic, retain) <ConductorDelegate> delegate;

- (void) start;
- (void) finish;

@end
