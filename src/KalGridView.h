/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalDayTileView, KalWeekView, KalMonthView, KalLogic, KalDate;
@protocol KalViewDelegate;

/*
 *    KalGridView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalView).
 *
 */
@interface KalGridView : UIView
{
	id<KalViewDelegate> delegate;  // Assigned.
	KalLogic *logic;
	KalMonthView *frontMonthView;
	KalMonthView *backMonthView;
	KalDayTileView *selectedTile;
	BOOL transitioning;
}

@property (nonatomic, readonly) BOOL transitioning;
@property (nonatomic, readonly) NSArray *selectedDates;
@property (nonatomic, readonly) BOOL isShowingWeekView;
@property (nonatomic) BOOL allowsMultipleSelection;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalViewDelegate>)delegate;
- (void)selectNone;
- (void)selectDate:(KalDate *)date;
- (void)selectDates:(NSArray *)dates;
- (void)markTilesWithAnnoatations:(NSArray *)annotationsList;

// These 3 methods should be called *after* the KalLogic
// has moved to the previous or following month.
- (void)showPreviousWeek;
- (void)showFollowingWeek;
- (void)showFollowingMonth;
- (void)showPreviousMonth;
- (void)jumpToSelectedMonth;    // see comment on KalView

@end
