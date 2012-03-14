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

@implementation KalAnnotationView

@synthesize annotations;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.userInteractionEnabled = NO;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
		
		NSMutableArray *array = [NSMutableArray array];

		KalAnnotation *annotation = nil;
		annotation = [[KalAnnotation alloc] init];
		annotation.percentOfDay = rand()/(float)RAND_MAX;
		annotation.backgroundColour = [UIColor colorWithRed:rand()/(float)RAND_MAX
													  green:rand()/(float)RAND_MAX
													   blue:rand()/(float)RAND_MAX
													  alpha:1.0];
		[array addObject:annotation];
		[annotation release];
		
		annotation = [[KalAnnotation alloc] init];
		annotation.percentOfDay = rand()/(float)RAND_MAX;
		annotation.backgroundColour = [UIColor colorWithRed:rand()/(float)RAND_MAX
													  green:rand()/(float)RAND_MAX
													   blue:rand()/(float)RAND_MAX
													  alpha:1.0];
		[array addObject:annotation];
		[annotation release];
		
		annotation = [[KalAnnotation alloc] init];
		annotation.percentOfDay = rand()/(float)RAND_MAX;
		annotation.backgroundColour = [UIColor colorWithRed:rand()/(float)RAND_MAX
													  green:rand()/(float)RAND_MAX
													   blue:rand()/(float)RAND_MAX
													  alpha:1.0];
		[array addObject:annotation];
		[annotation release];
		
		annotations = [[KalDayAnnotations alloc] init];
		annotations.annotations = array;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	NSLog(@"Drawing annotations...");
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	float totalPercentage = 0;
	float currentY = 0;
	for (KalAnnotation *annotation in annotations.annotations) {
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
	[annotations release];
	[super dealloc];
}

@end
