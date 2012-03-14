//
//  KalAnnotation.h
//  Kal
//
//  Created by Vinay Chavan on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KalAnnotation : NSObject
@property (nonatomic, retain) UIColor * backgroundColour;
@property (nonatomic, retain) UIColor * borderColour;
@property (nonatomic, assign) float borderWidth;
@property (nonatomic, assign) BOOL isBorderDashed;
@property (nonatomic, assign) float percentOfDay;
@end
