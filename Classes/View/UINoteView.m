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
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //UIImageView *bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar-top.png"]];
        
        UIImage *backgroundRaw = [UIImage imageNamed:@"bar-bg.png"];
        //NSInteger cap = backgroundRaw.size.height / 2 - 1;
        //UIImageView *background = [[UIImageView alloc] initWithImage:[backgroundRaw stretchableImageWithLeftCapWidth:0 topCapHeight:cap]];
        UIImageView *background = [[UIImageView alloc] initWithImage:backgroundRaw];
        
        //bar.contentMode = UIViewContentModeTop;
        background.contentMode = UIViewContentModeScaleToFill;
        background.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        background.frame = CGRectMake(0, 0, value.size.width, value.size.height);
        
        [self addSubview:background];
        //[self addSubview:bar];
        
        self.clipsToBounds = YES;
        
        [background release];
        //[bar release];
    }
    return self;
}

@end
