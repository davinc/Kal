//
//  KalAnnotation.m
//  Kal
//
//  Created by Vinay Chavan on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KalAnnotation.h"

@implementation KalAnnotation

@synthesize backgroundColour = _backgroundColour;
@synthesize borderColour = _borderColour;
@synthesize borderWidth = _borderWidth;
@synthesize isBorderDashed = _isBorderDashed;
@synthesize percentOfDay = _percentOfDay;

- (void)dealloc {
    // Free our resources
    [_backgroundColour release];
    _backgroundColour = nil;
    [_borderColour release];
    _borderColour = nil;
	
    // Call to base
    [super dealloc];
}

@end
