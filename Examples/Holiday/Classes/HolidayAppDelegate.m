/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "HolidayAppDelegate.h"
#import "HolidaySqliteDataSource.h"
#import "HolidaysDetailViewController.h"
#import "Kal.h"

@implementation HolidayAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	/*
	 *    Kal Initialization
	 *
	 * When the calendar is first displayed to the user, Kal will automatically select today's date.
	 * If your application requires an arbitrary starting date, use -[KalViewController initWithSelectedDate:]
	 * instead of -[KalViewController init].
	 */
	kal = [[KalViewController alloc] init];
	kal.title = @"Example";
	
	/*
	 *    Kal Configuration
	 *
	 * This demo app includes 2 example datasources for the Kal component. Both datasources
	 * contain 2009-2011 holidays, however, one datasource retrieves the data
	 * from a remote web server using JSON while the other datasource retrieves the data
	 * from a local Sqlite database. For this demo, I am going to set it up to just use
	 * the Sqlite database.
	 */
	kal.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" 
																			  style:UIBarButtonItemStyleBordered 
																			 target:self 
																			 action:@selector(showAndSelectToday)] autorelease];
	kal.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Weekdays"
																			 style:UIBarButtonItemStyleBordered
																			target:self
																			action:@selector(selectWeekDays)] autorelease];
	
	kal.delegate = self;
	dataSource = [[HolidaySqliteDataSource alloc] init];
	kal.dataSource = dataSource;
	
	// Setup the navigation stack and display it.
	navController = [[UINavigationController alloc] initWithRootViewController:kal];
	[window addSubview:navController.view];
	[window makeKeyAndVisible];
}

// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
	[kal showAndSelectDate:[NSDate date]];
}

- (void)selectWeekDays
{
	NSMutableArray *dates = [NSMutableArray array];
	
	for (int i = 0; i < 13; i++) {
		[dates addObject:[[NSDate date] dateByAddingTimeInterval:60*60*24*i]];
	}
	
	[kal selectDates:dates];
}

#pragma mark -

- (void)dealloc
{
	[kal release];
	[dataSource release];
	[window release];
	[navController release];
	[super dealloc];
}

@end
