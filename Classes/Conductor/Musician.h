//
//  Musician.h
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Musician : NSObject {
	NSString *peerID;
	NSString *displayName;
	NSString *pitch;
}

@property (nonatomic, retain) NSString *peerID;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *pitch;

@end
