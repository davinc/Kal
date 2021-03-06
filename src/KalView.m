/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"

@interface KalView ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

static const CGFloat kHeaderHeight = 20.f;
static const CGFloat kMonthLabelHeight = 17.f;

@implementation KalView

@synthesize delegate;
@synthesize allowsMultipleSelection;
@synthesize logic;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
{
	if ((self = [super initWithFrame:frame])) {
		delegate = theDelegate;
		logic = [theLogic retain];
		[logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		
		UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
		headerView.backgroundColor = [UIColor grayColor];
		[self addSubviewsToHeaderView:headerView];
		[self addSubview:headerView];
		
		UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)] autorelease];
		contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self addSubviewsToContentView:contentView];
		[self addSubview:contentView];
		
		UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformSwipeGesture:)];
		swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
		[self addGestureRecognizer:swipeLeft];
		[swipeLeft release], swipeLeft = nil;
		
		UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformSwipeGesture:)];
		swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
		[self addGestureRecognizer:swipeRight];
		[swipeRight release], swipeRight = nil;
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	[NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
	return nil;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)showPreviousMonth 
{
	[gridView showPreviousMonth]; 
}
- (void)showFollowingMonth
{
	[gridView showFollowingMonth]; 
}

- (void)showPreviousWeek
{
	[gridView showPreviousWeek];
}

- (void)showFollowingWeek
{
	[gridView showFollowingWeek];
}

- (void)didTapPrevious:(id)sender
{
	if (!gridView.transitioning) {
		[delegate showPreviousMonth];
	}
}

- (void)didTapNext:(id)sender
{
	if (!gridView.transitioning) {
		[delegate showFollowingMonth];
	}
}

- (void)didPerformSwipeGesture:(UISwipeGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
		if (gridView.isShowingWeekView) {
			if (!gridView.transitioning) {
				[delegate showFollowingWeek];
			}
		}else {
			if (!gridView.transitioning) {
				[delegate showFollowingMonth];
			}
		}
	}else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		if (gridView.isShowingWeekView) {
			if (!gridView.transitioning) {
				[delegate showPreviousWeek];
			}
		}else {
			if (!gridView.transitioning) {
				[delegate showPreviousMonth];
			}
		}
	}
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
//	const CGFloat kChangeMonthButtonWidth = 46.0f;
//	const CGFloat kChangeMonthButtonHeight = 30.0f;
//	const CGFloat kMonthLabelWidth = 200.0f;
//	const CGFloat kHeaderVerticalAdjust = 3.f;
//	
	// Header background gradient
	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Kal.bundle/kal_grid_background.png"]];
	CGRect imageFrame = headerView.frame;
	imageFrame.origin = CGPointZero;
	backgroundView.frame = imageFrame;
	[headerView addSubview:backgroundView];
	[backgroundView release];
//	
//	// Create the previous month button on the left side of the view
//	CGRect previousMonthButtonFrame = CGRectMake(self.left,
//												 kHeaderVerticalAdjust,
//												 kChangeMonthButtonWidth,
//												 kChangeMonthButtonHeight);
//	UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
//	[previousMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_left_arrow.png"] forState:UIControlStateNormal];
//	previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//	previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//	[previousMonthButton addTarget:self action:@selector(didTapPrevious:) forControlEvents:UIControlEventTouchUpInside];
//	[headerView addSubview:previousMonthButton];
//	[previousMonthButton release];
//	
//	// Draw the selected month name centered and at the top of the view
//	CGRect monthLabelFrame = CGRectMake((self.width - kMonthLabelWidth)/2.0f,
//										kHeaderVerticalAdjust,
//										kMonthLabelWidth,
//										kMonthLabelHeight);
//	headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
//	headerTitleLabel.backgroundColor = [UIColor clearColor];
//	headerTitleLabel.font = [UIFont boldSystemFontOfSize:22.f];
//	headerTitleLabel.textAlignment = UITextAlignmentCenter;
//	headerTitleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_header_text_fill.png"]];
//	headerTitleLabel.shadowColor = [UIColor whiteColor];
//	headerTitleLabel.shadowOffset = CGSizeMake(0.f, 1.f);
//	[self setHeaderTitleText:[logic selectedMonthNameAndYear]];
//	[headerView addSubview:headerTitleLabel];
//	
//	// Create the next month button on the right side of the view
//	CGRect nextMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth,
//											 kHeaderVerticalAdjust,
//											 kChangeMonthButtonWidth,
//											 kChangeMonthButtonHeight);
//	UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
//	[nextMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_right_arrow.png"] forState:UIControlStateNormal];
//	nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//	nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//	[nextMonthButton addTarget:self action:@selector(didTapNext:) forControlEvents:UIControlEventTouchUpInside];
//	[headerView addSubview:nextMonthButton];
//	[nextMonthButton release];
	
	// Add column labels for each weekday (adjusting based on the current locale's first weekday)
	NSArray *weekdayNames = [[[[NSDateFormatter alloc] init] autorelease] shortWeekdaySymbols];
	NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
	CGFloat offset = self.bounds.size.width / 8;
	NSUInteger i = firstWeekday - 1;
	for (CGFloat xOffset = offset; xOffset < headerView.width; xOffset += offset, i = (i+1)%7) {
		CGRect weekdayFrame = CGRectMake(xOffset, 0.f, offset, kHeaderHeight);
		UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
		weekdayLabel.backgroundColor = [UIColor clearColor];
		weekdayLabel.font = [UIFont boldSystemFontOfSize:11.f];
		weekdayLabel.textAlignment = UITextAlignmentCenter;
		weekdayLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.f];
		weekdayLabel.shadowColor = [UIColor whiteColor];
		weekdayLabel.shadowOffset = CGSizeMake(0.f, 1.f);
		weekdayLabel.text = [weekdayNames objectAtIndex:i];
		[headerView addSubview:weekdayLabel];
		[weekdayLabel release];
	}
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
	// Both the tile grid and the list of events will automatically lay themselves
	// out to fit the # of weeks in the currently displayed month.
	// So the only part of the frame that we need to specify is the width.
	CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, self.height - kHeaderHeight);
	
	// The tile grid (the calendar body)
	gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
//	[gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
	[contentView addSubview:gridView];
	
	// Trigger the initial KVO update to finish the contentView layout
//	[gridView sizeToFit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == gridView && [keyPath isEqualToString:@"frame"]) {
		
		/* Animate tableView filling the remaining space after the
		 * gridView expanded or contracted to fit the # of weeks
		 * for the month that is being displayed.
		 *
		 * This observer method will be called when gridView's height
		 * changes, which we know to occur inside a Core Animation
		 * transaction. Hence, when I set the "frame" property on
		 * tableView here, I do not need to wrap it in a
		 * [UIView beginAnimations:context:].
		 */
		
	} else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
		[self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
		
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)setHeaderTitleText:(NSString *)text
{
	[headerTitleLabel setText:text];
	[headerTitleLabel sizeToFit];
	headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { [gridView jumpToSelectedMonth]; }

- (void)selectNone { [gridView selectNone]; }

- (void)selectDate:(KalDate *)date { [gridView selectDate:date]; }

- (void)selectDates:(NSArray *)dates { [gridView selectDates:dates]; }

- (BOOL)isSliding { return gridView.transitioning; }

//- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }

- (void)markTilesWithAnnoatations:(NSArray *)annotationsList { [gridView markTilesWithAnnoatations:annotationsList]; }

- (NSArray *)selectedDates { return gridView.selectedDates; }

- (BOOL)allowsMultipleSelection { return gridView.allowsMultipleSelection; }
- (void)setAllowsMultipleSelection:(BOOL)multipleSelection { [gridView setAllowsMultipleSelection:multipleSelection]; }

- (void)dealloc
{
	[logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
	[logic release];
	
	[headerTitleLabel release];
	[gridView removeObserver:self forKeyPath:@"frame"];
	[gridView release];
	[super dealloc];
}

@end
