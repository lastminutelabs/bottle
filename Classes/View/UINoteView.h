//
//  UINoteView.h
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface UINoteView : UIView {
	Note *note;
}

@property (nonatomic, retain) Note *note;

@end
