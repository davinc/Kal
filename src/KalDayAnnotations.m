//
//  KalDayAnnotations.m
//  Kal
//
//  Created by Vinay Chavan on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KalDayAnnotations.h"
#import "KalDate.h"
#import "KalAnnotation.h"

@implementation KalDayAnnotations

@synthesize date;
@synthesize annotations;

- (void)dealloc
{
	[date release];
	[annotations release];
	[super dealloc];
}

@end
