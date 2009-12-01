//
//  UINoteView.m
//  Bottle
//
//  Created by Sam Dean on 26/09/2009.
//  Copyright 2009 lastminute.com. All rights reserved.
//

#import "UINoteView.h"


@implementation UINoteView

@synthesize note;

- (id) initWithFrame:(CGRect)value {
    if (self = [super initWithFrame:value]) {
        UIImageView *bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar-top.png"]];
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar-bg.png"]];
        
        bar.contentMode = UIViewContentModeTop;
        background.contentMode = UIViewContentModeScaleToFill;
        background.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        background.frame = CGRectMake(0, 0, value.size.width, value.size.height);
        
        [self addSubview:background];
        [self addSubview:bar];
        
        self.clipsToBounds = YES;
        
        [background release];
        [bar release];
    }
    return self;
}

@end
