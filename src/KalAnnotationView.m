//
//  KalAnnotationView.m
//  Kal
//
//  Created by Vinay Chavan on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KalAnnotationView.h"
#import "KalDayAnnotations.h"
#import "KalAnnotation.h"
#import "KalDate.h"

@implementation KalAnnotationView

@synthesize dayAnnotations;

//float randFloat(void) {
//    return rand()/(float)RAND_MAX;
//}
//- (KalDayAnnotations *)annotationsForDate:(NSDate *)date
//{
//	KalDayAnnotations *dayAnnotation = [[KalDayAnnotations alloc] init];
//	dayAnnotation.date = [KalDate dateFromNSDate:date];
//	
//	int numberAnnotations = arc4random() % 10;
//    if (numberAnnotations < 1) {
//		//        return nil;
//    }
//    NSMutableArray * annotations = [NSMutableArray array];
//    float totalPercentUsed = 0;
//    for (int i = 0; i < numberAnnotations; i++) {
//        KalAnnotation * annotation = [[KalAnnotation alloc] init];
//        [annotations addObject:annotation];
//        
//        int r = (arc4random() % 100);
//        annotation.isBorderDashed = r > 50;
//		
//        float bgR = randFloat();
//        float bgG = randFloat();
//        float bgB = randFloat();
//        annotation.backgroundColour = [UIColor colorWithRed:bgR green:bgG blue:bgB alpha:annotation.isBorderDashed ? 0.2 : 1];
//        annotation.borderColour = annotation.isBorderDashed ? [UIColor colorWithRed:randFloat() green:randFloat() blue:randFloat() alpha:1] : [UIColor clearColor];
//        annotation.borderWidth = annotation.isBorderDashed ? arc4random() % 4 : 0;
//        
//        float percentToUse = randFloat();
//        if (percentToUse + totalPercentUsed > 1.f)
//            percentToUse = 1.f - totalPercentUsed;
//        annotation.percentOfDay = percentToUse;        
//		
//        totalPercentUsed += percentToUse;
//        NSLog(@"\t%.1f%% of day with bg %.0f %.0f %.0f   border %.1fpx    Dashed? %@   Total now: %.1f%%", (annotation.percentOfDay * 100), bgR * 255, bgG * 255, bgB * 255, annotation.borderWidth, annotation.isBorderDashed ? @"Yes" : @"No", totalPercentUsed * 100);
//		
//		[annotation release];
//		annotation = nil;
//		if (totalPercentUsed >= 1.f)
//            break;
//    }
//	dayAnnotation.annotations = annotations;
//	
//	return [dayAnnotation autorelease];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.userInteractionEnabled = NO;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
		
//		self.dayAnnotations = [self annotationsForDate:nil];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	float totalPercentage = 0;
	float currentY = 0;
	for (KalAnnotation *annotation in dayAnnotations.annotations) {
		float percentage = annotation.percentOfDay;
		float height = self.bounds.size.height * percentage;
		
		CGContextSetFillColorWithColor(ctx, annotation.backgroundColour.CGColor);
		CGRect annotationRect = CGRectMake(0, currentY, self.bounds.size.width, height);
		CGContextAddRect(ctx, annotationRect);
		CGContextFillPath(ctx);
		float borderOffset = annotation.borderWidth / 2;
		CGRect borderRect = CGRectMake(0+borderOffset, currentY+borderOffset, self.bounds.size.width-annotation.borderWidth, height-annotation.borderWidth);
		CGContextAddRect(ctx, borderRect);
		CGContextSetStrokeColorWithColor(ctx, annotation.borderColour.CGColor);
		CGContextSetLineWidth(ctx, annotation.borderWidth);
		CGFloat dashes[] = { 5, annotation.isBorderDashed ? 5 : 0 };
		CGContextSetLineDash(ctx, 0, dashes, 2);	
		CGContextStrokePath(ctx);
		
		totalPercentage += percentage;
		currentY += height;
	}
}

- (void)dealloc
{
	[dayAnnotations release];
	[super dealloc];
}

@end
