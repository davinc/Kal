/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"

@interface KalLogic ()
- (void)moveToMonthForDate:(NSDate *)date;
- (void)recalculateVisibleDays;
- (NSUInteger)numberOfDaysInPreviousPartialWeek;
- (NSUInteger)numberOfDaysInFollowingPartialWeek;

@property (nonatomic, retain) NSDate *fromDate;
@property (nonatomic, retain) NSDate *toDate;
@property (nonatomic, retain) NSArray *daysInSelectedMonth;
@property (nonatomic, retain) NSArray *daysInFinalWeekOfPreviousMonth;
@property (nonatomic, retain) NSArray *daysInFirstWeekOfFollowingMonth;
@property (nonatomic, retain) NSArray *daysInSelectedWeek;

@end

@implementation KalLogic

@synthesize baseDate, fromDate, toDate, daysInSelectedMonth, daysInFinalWeekOfPreviousMonth, daysInFirstWeekOfFollowingMonth, daysInSelectedWeek, logicMode;

+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
	return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
	if ((self = [super init])) {
		logicMode = KalLogicMonthMode;
		
		monthAndYearFormatter = [[NSDateFormatter alloc] init];
		[monthAndYearFormatter setDateFormat:@"LLLL yyyy"];
		[self moveToMonthForDate:date];
	}
	return self;
}

- (id)init
{
	return [self initForDate:[NSDate date]];
}

- (void)moveToMonthForDate:(NSDate *)date
{
	if (logicMode == KalLogicMonthMode) {
		self.baseDate = [date cc_dateByMovingToFirstDayOfTheMonth];
		[self recalculateVisibleDays];
	}
}

- (void)moveToWeekForDate:(NSDate *)date
{
	if (logicMode == KalLogicWeekMode) {
		self.baseDate = [date cc_dateByMovingToFirstDayOfTheWeek];
		[self recalculateVisibleDays];
	}
}

- (void)retreatToPreviousMonth
{
	[self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth]];
}

- (void)advanceToFollowingMonth
{
	[self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth]];
}

- (void)retreatToPreviousWeek
{
	[self moveToWeekForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousWeek]];
}

- (void)advanceToFollowingWeek
{
	[self moveToWeekForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingWeek]];
}

- (NSString *)selectedMonthNameAndYear
{
	return [monthAndYearFormatter stringFromDate:self.baseDate];
}

#pragma mark Low-level implementation details

- (NSUInteger)numberOfDaysInPreviousPartialWeek
{
	return [self.baseDate cc_weekday] - 1;
}

- (NSUInteger)numberOfDaysInFollowingPartialWeek
{
	NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
	c.day = [self.baseDate cc_numberOfDaysInMonth];
	NSDate *lastDayOfTheMonth = [[NSCalendar currentCalendar] dateFromComponents:c];
	return 7 - [lastDayOfTheMonth cc_weekday];
}

- (NSArray *)calculateDaysInFinalWeekOfPreviousMonth
{
	NSMutableArray *days = [NSMutableArray array];
	
	NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth];
	int n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
	int numPartialDays = [self numberOfDaysInPreviousPartialWeek];
	NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
	for (int i = n - (numPartialDays - 1); i < n + 1; i++)
		[days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
	
	return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
	NSMutableArray *days = [NSMutableArray array];
	
	NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
	NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
	for (int i = 1; i < numDays + 1; i++)
		[days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
	
	return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
	NSMutableArray *days = [NSMutableArray array];
	
	NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
	NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
	
	for (int i = 1; i < numPartialDays + 1; i++)
		[days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
	
	return days;
}

- (NSArray *)calculateDaysInSelectedWeek
{
	NSMutableArray *days = [NSMutableArray array];
	
	NSUInteger numDays = 7;
	for (int i = 0; i < numDays; i++)
		[days addObject:[KalDate dateFromNSDate:[self.baseDate dateByAddingTimeInterval:60*60*24*i]]];
	
	return days;
}

- (void)recalculateVisibleDays
{
	if (logicMode == KalLogicMonthMode) 
	{
		self.daysInSelectedMonth = [self calculateDaysInSelectedMonth];
		self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
		self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
		KalDate *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
		KalDate *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
		self.fromDate = [[from NSDate] cc_dateByMovingToBeginningOfDay];
		self.toDate = [[to NSDate] cc_dateByMovingToEndOfDay];
	}else if (logicMode == KalLogicWeekMode) 
	{
		self.daysInSelectedWeek = [self calculateDaysInSelectedWeek];
		self.fromDate = [self.baseDate cc_dateByMovingToBeginningOfDay];
		self.toDate = [[self.fromDate dateByAddingTimeInterval:60*60*24*6] cc_dateByMovingToEndOfDay];
	}
}

#pragma mark -

- (void) dealloc
{
	[monthAndYearFormatter release];
	[baseDate release];
	[fromDate release];
	[toDate release];
	[daysInSelectedMonth release];
	[daysInFinalWeekOfPreviousMonth release];
	[daysInFirstWeekOfFollowingMonth release];
	[daysInSelectedWeek release];
	[super dealloc];
}

@end
