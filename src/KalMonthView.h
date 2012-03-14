/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalWeekView, KalDayTileView, KalWeekTileView, KalDate;

@interface KalMonthView : UIView
{
	NSUInteger numWeeks;
	BOOL isShowingWeekView;
}

@property (nonatomic) BOOL isShowingWeekView;

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates;
- (KalDayTileView *)firstTileOfMonth;
- (KalDayTileView *)tileForDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;

- (void)showWeekViewForWeekAtIndex:(NSInteger)index;
- (void)hideWeekView;

@end
