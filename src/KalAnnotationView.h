//
//  KalAnnotationView.h
//  Kal
//
//  Created by Vinay Chavan on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KalDayAnnotations;

@interface KalAnnotationView : UIView
{
	KalDayAnnotations *annotations;
}

@property (nonatomic, retain) KalDayAnnotations *annotations;

@end
