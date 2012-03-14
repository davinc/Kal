/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalWeekView.h"
#import "KalDayTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"

@implementation KalMonthView

@synthesize isShowingWeekView;

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		self.opaque = NO;
		self.clipsToBounds = YES;
		self.isShowingWeekView = NO;
		for (int i=0; i<6; i++) {
			[self addSubview:[[[KalWeekView alloc] initWithFrame:CGRectZero] autorelease]];
		}
	}
	return self;
}

- (void)layoutSubviews
{
	if (numWeeks == 0 || isShowingWeekView) {
		return;
	}
	CGSize tileSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height/numWeeks);
	
	for (int i=0; i<6; i++) 
	{
		CGRect r = CGRectMake(0.f, i*tileSize.height, tileSize.width, tileSize.height);
		UIView *subview = [self.subviews objectAtIndex:i];
		if ([subview isKindOfClass:[KalWeekView class]]) 
		{
			subview.frame = r;
		}
	}
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
	int dayTileNum = 0;
	int weekTileNum = 0;
	int tileNum = 0;
	NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
	
	for (int i=0; i<3; i++) {
		for (KalDate *d in dates[i]) {
			UIView *view = [self.subviews objectAtIndex:weekTileNum];
			if ([view isKindOfClass:[KalWeekView class]]) {
				KalWeekView *weekView = (KalWeekView *)view;
				weekView.weekIndex = weekTileNum;
				[weekView setTitleText:[NSString stringWithFormat:@"Wk%d", weekTileNum+1]];
				
				KalDayTileView *dayTile = [weekView.dayTiles objectAtIndex:dayTileNum];
				
				[dayTile resetState];
				dayTile.date = d;
				dayTile.type = (dates[i] != mainDates) ? KalTileTypeAdjacent:[d isToday]?KalTileTypeToday:KalTileTypeRegular;
				tileNum++;
				dayTileNum++;
				if (dayTileNum == 7) {
					dayTileNum = 0;
					weekTileNum++;
				}
			}
		}
	}
	
	numWeeks = ceilf(tileNum / 7.f);
	[self sizeToFit];
	[self setNeedsLayout];
}

- (KalDayTileView *)firstTileOfMonth
{
	KalDayTileView *tile = nil;
	for (KalWeekView *weekView in self.subviews) {
		for (KalDayTileView *t in weekView.dayTiles) {
			if (!t.belongsToAdjacentMonth) {
				tile = t;
				break;
			}
		}
		if (tile) break;
	}
	
	return tile;
}

- (KalDayTileView *)tileForDate:(KalDate *)date
{
	KalDayTileView *tile = nil;
	for (KalWeekView *weekView in self.subviews) {
		for (KalDayTileView *t in weekView.dayTiles) {
			if ([t.date isEqual:date]) {
				tile = t;
				break;
			}
		}
		if (tile) break;
	}
	NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
	
	return tile;
}

- (void)markTilesForDates:(NSArray *)dates
{
//	for (UIView *view in self.subviews)
//	{
//		if ([view isKindOfClass:[KalDayTileView class]]) {
//			KalDayTileView *tile = (KalDayTileView*)view;
//			tile.marked = [dates containsObject:tile.date];
//		}
//	}
}

- (void)showWeekViewForWeekAtIndex:(NSInteger)index
{
	[UIView beginAnimations:nil context:nil];
	
	int weekIndex = 0;
	for (KalWeekView *weekView in self.subviews) {
		if (weekIndex < index) {
			weekView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
		}else if (weekIndex == index){
			weekView.frame = self.bounds;
		}else {
			weekView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0);
		}
		weekIndex++;
	}
	
	[UIView commitAnimations];
	
	self.isShowingWeekView = YES;
}

- (void)hideWeekView
{
	self.isShowingWeekView = NO;

	[UIView beginAnimations:nil context:nil];
	
	[self layoutSubviews];
	
	[UIView commitAnimations];
}

@end
