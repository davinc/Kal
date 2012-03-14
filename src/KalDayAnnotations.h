//
//  KalDayAnnotations.h
//  Kal
//
//  Created by Vinay Chavan on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KalAnnotation, KalDate;

@interface KalDayAnnotations : NSObject
{
	KalDate *date;
	NSArray *annotations;
}

@property (nonatomic, retain) KalDate *date;
@property (nonatomic, retain) NSArray *annotations;

@end
