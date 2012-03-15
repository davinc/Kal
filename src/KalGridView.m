/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>

#import "KalGridView.h"
#import "KalView.h"
#import "KalMonthView.h"
#import "KalWeekView.h"
#import "KalDayTileView.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"

#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2
#define SLIDE_LEFT 3
#define SLIDE_RIGHT 4

static NSString *kSlideAnimationId = @"KalSwitchMonths";

@interface KalGridView ()
@property (nonatomic, retain) KalDayTileView *highlightedTile;
@property (nonatomic, retain) KalDayTileView *selectedTile;
- (void)swapMonthViews;
@end

@implementation KalGridView

@synthesize highlightedTile, selectedTile;
@synthesize transitioning;
@synthesize allowsMultipleSelection;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalViewDelegate>)theDelegate
{	
	if (self = [super initWithFrame:frame]) {
		self.clipsToBounds = YES;
		self.allowsMultipleSelection = NO;
		logic = [theLogic retain];
		delegate = theDelegate;
		
		CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
		frontMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
		backMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
		backMonthView.hidden = YES;
		[self addSubview:backMonthView];
		[self addSubview:frontMonthView];
		
		[self jumpToSelectedMonth];
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	[[UIImage imageNamed:@"Kal.bundle/kal_grid_background.png"] drawInRect:rect];
	[[UIColor colorWithRed:0.63f green:0.65f blue:0.68f alpha:1.f] setFill];
	CGRect line;
	line.origin = CGPointMake(0.f, self.height - 1.f);
	line.size = CGSizeMake(self.width, 1.f);
	CGContextFillRect(UIGraphicsGetCurrentContext(), line);
}

- (void)sizeToFit
{
//	self.height = frontMonthView.height;
}

#pragma mark -
#pragma mark Touches

- (void)setHighlightedTile:(KalDayTileView *)tile
{
	if (highlightedTile != tile) {
		highlightedTile.highlighted = NO;
		highlightedTile = [tile retain];
		[tile setNeedsDisplay];
	}
}

- (void)setSelectedTile:(KalDayTileView *)tile
{
	if (allowsMultipleSelection) 
	{
		// should work like toggle
		tile.selected = !tile.selected;
		[selectedTile release], selectedTile = nil;
	}else 
	{
		// should deselect previous
		if (selectedTile != tile) {
			selectedTile.selected = NO;
			[selectedTile release], selectedTile = nil;
			selectedTile = [tile retain];
			selectedTile.selected = YES;
			[tile setNeedsDisplay];
		}
	}

	if (tile.selected) {
		[delegate didSelectDate:tile.date];
	}
}

- (void)receivedTouches:(NSSet *)touches withEvent:event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	UIView *hitView = [self hitTest:location withEvent:event];
	
	if (!hitView)
		return;
	
	if ([hitView isKindOfClass:[KalDayTileView class]]) {
		KalDayTileView *tile = (KalDayTileView*)hitView;
		if (tile.belongsToAdjacentMonth) {
			self.highlightedTile = tile;
		} else {
			self.highlightedTile = nil;
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self receivedTouches:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self receivedTouches:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	UIView *hitView = [self hitTest:location withEvent:event];
	
	if ([hitView isKindOfClass:[KalDayTileView class]]) {
		KalDayTileView *tile = (KalDayTileView*)hitView;
		if (tile.belongsToAdjacentMonth) {
			//      if ([tile.date compare:[KalDate dateFromNSDate:logic.baseDate]] == NSOrderedDescending) {
			//        [delegate showFollowingMonth];
			//      } else {
			//        [delegate showPreviousMonth];
			//      }
			//      self.selectedTile = [frontMonthView tileForDate:tile.date];
		} else {
			[self setSelectedTile:tile];
		}
	}else if ([hitView isKindOfClass:[KalWeekView class]]) {
		// Call back for weekview
		KalWeekView *weekView = (KalWeekView *)hitView;
		NSLog(@"%i", weekView.weekIndex);
		// show that week
		
		if (frontMonthView.isShowingWeekView) {
//			logic.logicMode = KalLogicMonthMode;
			[frontMonthView hideWeekView];
		}else {
//			logic.logicMode = KalLogicWeekMode;
			[frontMonthView showWeekViewForWeekAtIndex:weekView.weekIndex];
		}
	}
	//  self.highlightedTile = nil;
}

#pragma mark -
#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
	transitioning = YES;

	backMonthView.hidden = NO;
	
	// set initial positions before the slide
	if (direction == SLIDE_LEFT) {
		backMonthView.left = -frontMonthView.width;
	} else if (direction == SLIDE_RIGHT) {
		backMonthView.left = frontMonthView.width;
	}
	
	// trigger the slide animation
	[UIView beginAnimations:kSlideAnimationId context:NULL]; 
	{
		[UIView setAnimationsEnabled:direction!=SLIDE_NONE];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		
		frontMonthView.left = -backMonthView.left;
		backMonthView.top = 0.f;
		backMonthView.left = 0.f;
		
		frontMonthView.alpha = 0.f;
		backMonthView.alpha = 1.f;
		
		self.height = backMonthView.height;
		
		[self swapMonthViews];
	}
	[UIView commitAnimations];
	[UIView setAnimationsEnabled:YES];
}

- (void)slide:(int)direction
{
	NSInteger weekIndex = 0;
	if (frontMonthView.isShowingWeekView) {
		weekIndex = frontMonthView.showingWeekOfMonth;
		weekIndex = weekIndex + (direction == SLIDE_LEFT?-1:1);
		
		if (weekIndex < 0 && direction == SLIDE_LEFT) {
			return;
		}
		if (frontMonthView.numberOfWeeks-1 < weekIndex && direction == SLIDE_RIGHT) {
			return;
		}
	}else {
		backMonthView.isShowingWeekView = NO;
	}
	
	[backMonthView showDates:logic.daysInSelectedMonth
		leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
	   trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth];
	
	// At this point, the calendar logic has already been advanced or retreated to the
	// following/previous month, so in order to determine whether there are 
	// any cells to keep, we need to check for a partial week in the month
	// that is sliding offscreen.
	if (frontMonthView.isShowingWeekView) {
		[backMonthView showWeekViewForWeekAtIndex:weekIndex];
	}
	
	BOOL keepOneRow = (direction == SLIDE_UP && [logic.daysInFinalWeekOfPreviousMonth count] > 0)
	|| (direction == SLIDE_DOWN && [logic.daysInFirstWeekOfFollowingMonth count] > 0);
	
	[self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
}

- (void)showPreviousWeek
{
//	[frontMonthView showPreviousWeek];
	if (!transitioning)
		[self slide:SLIDE_LEFT]; 
}

- (void)showFollowingWeek
{
//	[frontMonthView showFollowingWeek];
	if (!transitioning)
		[self slide:SLIDE_RIGHT]; 
}

- (void)showFollowingMonth
{
	if (!transitioning) {
		frontMonthView.isShowingWeekView = NO;
		[self slide:SLIDE_RIGHT]; 
	}
}

- (void)showPreviousMonth 
{ 
	if (!transitioning) {
		frontMonthView.isShowingWeekView = NO;
		[self slide:SLIDE_LEFT]; 
	}
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	transitioning = NO;
	backMonthView.hidden = YES;
}

#pragma mark -

- (void)selectDate:(KalDate *)date
{
	KalDayTileView *tile = [frontMonthView tileForDate:date];
	[self setSelectedTile:tile];
}

- (void)selectDates:(NSArray *)dates
{
	if (allowsMultipleSelection) {
		for (KalDate *date in dates) {
			KalDayTileView *tile = [frontMonthView tileForDate:date];
			tile.selected = YES;
		}
	}
}

- (void)swapMonthViews
{
	KalMonthView *tmp = backMonthView;
	backMonthView = frontMonthView;
	frontMonthView = tmp;
	[self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
	[self slide:SLIDE_NONE];
}

- (BOOL)isShowingWeekView { return frontMonthView.isShowingWeekView; }

//- (void)markTilesForDates:(NSArray *)dates { [frontMonthView markTilesForDates:dates]; }

- (void)markTilesWithAnnoatations:(NSArray *)annotationsList { [frontMonthView markTilesWithAnnoatations:annotationsList]; }

- (NSArray *)selectedDates
{
	//	return selectedTile.date; 
	return nil;
}

#pragma mark -

- (void)dealloc
{
	[selectedTile release];
	[highlightedTile release];
	[frontMonthView release];
	[backMonthView release];
	[logic release];
	[super dealloc];
}

@end
