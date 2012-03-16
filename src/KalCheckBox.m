//
//  KalCheckBox.m
//  timesheets
//
//  Created by Vinay Chavan on 16/03/12.
//  Copyright (c) 2012 Capgemini. All rights reserved.
//

#import "KalCheckBox.h"

@implementation KalCheckBox

@synthesize checked;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.userInteractionEnabled = NO;
		self.clipsToBounds = YES;
		self.opaque = YES;
		self.contentMode = UIViewContentModeBottom;
		
		self.image = [UIImage imageNamed:@"multiple_day_selector_on_calendar_unselected.png"];
    }
    return self;
}

- (void)setChecked:(BOOL)isChecked
{
	if (checked != isChecked) {
		checked = isChecked;
		
		UIImage *imageToSet = nil;
		if (checked) {
			imageToSet = [UIImage imageNamed:@"multiple_day_selector_on_calendar_selected.png"];
		}else {
			imageToSet = [UIImage imageNamed:@"multiple_day_selector_on_calendar_unselected.png"];
		}
		self.image = imageToSet;
	}
}

@end
