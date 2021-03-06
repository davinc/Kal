/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"

#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};
	
    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";

@interface KalViewController ()
@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
- (KalView*)calendarView;
@end

@implementation KalViewController

@synthesize dataSource, delegate, initialDate, selectedDate;

- (id)initWithSelectedDate:(NSDate *)date
{
	if ((self = [super init])) {
		logic = [[KalLogic alloc] initForDate:date];
		self.initialDate = date;
		self.selectedDate = date;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
	}
	return self;
}

- (id)init
{
	return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
	if (dataSource != aDataSource) {
		dataSource = aDataSource;
	}
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
	if (delegate != aDelegate) {
		delegate = aDelegate;
	}
}

- (void)clearTable
{
	[dataSource removeAllItems];
}

- (void)reloadData
{
	[dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

- (void)significantTimeChangeOccurred
{
	[[self calendarView] jumpToSelectedMonth];
	[self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(NSDate *)day
{
	KalDate *date = [KalDate dateFromNSDate:day];
	NSLog(@"Date selected: %d/%d/%d", date.day, date.month, date.year);
	self.selectedDate = [date NSDate];
	NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
	NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
	[self clearTable];
	[dataSource loadItemsFromDate:from toDate:to];
}

- (void)showPreviousMonth
{
	[self clearTable];
	[logic retreatToPreviousMonth];
	[[self calendarView] showPreviousMonth];
	[self reloadData];
}

- (void)showFollowingMonth
{
	[self clearTable];
	[logic advanceToFollowingMonth];
	[[self calendarView] showFollowingMonth];
	[self reloadData];
}

- (void)showPreviousWeek
{
	[self clearTable];
	[logic retreatToPreviousWeek];
	[[self calendarView] showPreviousWeek];
	[self reloadData];
}

- (void)showFollowingWeek
{
	[self clearTable];
	[logic advanceToFollowingWeek];
	[[self calendarView] showFollowingWeek];
	[self reloadData];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
//	NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
//	NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
//	for (int i=0; i<[dates count]; i++)
//		[dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
//	[[self calendarView] markTilesForDates:dates];
	
//	NSArray *dayAnnotations = [theDataSource dayAnnotationsFrom:logic.fromDate to:logic.toDate];
//	[[self calendarView] markTilesWithAnnoatations:dayAnnotations];
//	[self didSelectDate:self.calendarView.selectedDate];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
	if ([[self calendarView] isSliding])
		return;
	
	[logic moveToMonthForDate:date];
	
#if PROFILER
	uint64_t start, end;
	struct timespec tp;
	start = mach_absolute_time();
#endif
	
	[[self calendarView] jumpToSelectedMonth];
	
#if PROFILER
	end = mach_absolute_time();
	mach_absolute_difference(end, start, &tp);
	printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
	
	[[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
	[self reloadData];
}

- (NSArray *)selectedDates
{
	NSMutableArray *selectedDates = [NSMutableArray array];
	for (KalDate *date in self.calendarView.selectedDates) {
		[selectedDates addObject:[date NSDate]];
	}
	
	return selectedDates;
}

- (void)selectDates:(NSArray *)dates
{
	NSMutableArray *selectedDates = [NSMutableArray array];
	
	for (NSDate *date in dates) {
		[selectedDates addObject:[KalDate dateFromNSDate:date]];
	}
	
	[[self calendarView] selectDates:selectedDates];
}

// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)didReceiveMemoryWarning
{
	self.initialDate = self.selectedDate; // must be done before calling super
	[super didReceiveMemoryWarning];
}

- (void)loadView
{
	if (!self.title)
		self.title = @"Calendar";
	
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
	rect.size.height -= self.navigationController.navigationBar.bounds.size.height;
	
	KalView *kalView = [[[KalView alloc] initWithFrame:rect delegate:self logic:logic] autorelease];
	
	self.view = kalView;
	[kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
	[self reloadData];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
	[initialDate release];
	[selectedDate release];
	[logic release];
	[super dealloc];
}

@end
