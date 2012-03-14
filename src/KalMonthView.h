/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalWeekView, KalDayTileView, KalWeekTileView, KalDate, KalDayAnnotations, KalAnnotation;

@interface KalMonthView : UIView
{
	NSUInteger numWeeks;
	BOOL isShowingWeekView;
	NSInteger showingWeekOfMonth;
}

@property (nonatomic) BOOL isShowingWeekView;

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates;
- (KalDayTileView *)firstTileOfMonth;
- (KalDayTileView *)tileForDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;
- (void)markTilesWithAnnoatations:(NSArray *)annotationsList;

- (void)showWeekViewForWeekAtIndex:(NSInteger)index;
- (void)hideWeekView;
- (void)showPreviousWeek;
- (void)showFollowingWeek;

@end
