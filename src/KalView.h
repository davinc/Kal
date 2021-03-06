/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalGridView, KalLogic, KalDate;
@protocol KalViewDelegate, KalDataSourceCallbacks;

/*
 *    KalView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalViewController).
 *
 *  KalViewController uses KalView as its view.
 *  KalView defines a view hierarchy that looks like the following:
 *
 *       +-----------------------------------------+
 *       |                header view              |
 *       +-----------------------------------------+
 *       |                                         |
 *       |                                         |
 *       |                                         |
 *       |                 grid view               |
 *       |             (the calendar grid)         |
 *       |                                         |
 *       |                                         |
 *       +-----------------------------------------+
 *
 */
@interface KalView : UIView
{
	UILabel *headerTitleLabel;
	KalGridView *gridView;
	id<KalViewDelegate> delegate;
	KalLogic *logic;
}

@property (nonatomic, assign) id<KalViewDelegate> delegate;
@property (nonatomic, retain) KalLogic *logic;
@property (nonatomic, readonly) NSArray *selectedDates;
@property (nonatomic) BOOL allowsMultipleSelection;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)delegate logic:(KalLogic *)logic;
- (BOOL)isSliding;

- (void)selectNone;
- (void)selectDate:(KalDate *)date;
- (void)selectDates:(NSArray *)dates;

- (void)markTilesWithAnnoatations:(NSArray *)annotationsList;
- (void)redrawEntireMonth;

// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)showPreviousWeek;
- (void)showFollowingWeek;
- (void)showFollowingMonth;
- (void)showPreviousMonth;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")

@end

#pragma mark -

@class KalDate;

@protocol KalViewDelegate

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)showPreviousWeek;
- (void)showFollowingWeek;
- (void)didSelectDate:(NSDate *)date;

@end
