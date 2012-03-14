/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDataSource.h"
#import "KalPrivate.h"

@implementation SimpleKalDataSource

+ (SimpleKalDataSource*)dataSource
{
	return [[[[self class] alloc] init] autorelease];
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
	[delegate loadedDataSource:self];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
	return [NSArray array];
}

- (NSArray *)dayAnnotationsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
	return nil;
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
	// do nothing
}

- (void)removeAllItems
{
	// do nothing
}

@end
