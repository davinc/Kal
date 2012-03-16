//
//  KalWeekView.m
//  Kal
//
//  Created by Vinay Chavan on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KalWeekView.h"
#import "KalDayTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"

@implementation KalWeekView

@synthesize dayTiles;
@synthesize weekIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.opaque = YES;
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor lightGrayColor];
		
		dayTiles = [[NSMutableArray alloc] init];
		for (int j=0; j<7; j++) {
			KalDayTileView *tile = [[KalDayTileView alloc] initWithFrame:CGRectZero];
			[dayTiles addObject:tile];
			[self addSubview:tile];
			[tile release];
		}
		
		headerBackgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		headerBackgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];;
		[self addSubview:headerBackgroundImageView];
		
		headerLabel = [[UILabel alloc] initWithFrame:self.bounds];
		headerLabel.font = [UIFont boldSystemFontOfSize:11.f];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.f];
		headerLabel.shadowColor = [UIColor whiteColor];
		headerLabel.shadowOffset = CGSizeMake(-1, 0);
		headerLabel.transform = CGAffineTransformMakeRotation( -M_PI/2 );
		[self addSubview:headerLabel];		
    }
    return self;
}

- (void)layoutSubviews
{
	CGSize tileSize = CGSizeMake(self.bounds.size.width / 8.f, self.bounds.size.height);
	
	headerLabel.frame = CGRectMake(0, 0, tileSize.width, tileSize.height);
	headerBackgroundImageView.frame = CGRectMake(0, 0, tileSize.width, tileSize.height);
	
	// layout dates
	for (int i = 0; i < 7; i++) {
		CGRect r = CGRectMake(tileSize.width + i*tileSize.width, 0, tileSize.width, tileSize.height);
		UIView *subview = [dayTiles objectAtIndex:i];
		if ([subview isKindOfClass:[KalDayTileView class]]) {
			subview.frame = r;
		}
	}
}

- (void)setTitleText:(NSString *)text
{
	headerLabel.text = text;
}

- (void)dealloc
{
	[headerLabel release];
	[headerBackgroundImageView release];
	[dayTiles release];
	[super dealloc];
}

@end
