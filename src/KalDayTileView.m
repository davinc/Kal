/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDayTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "KalAnnotationView.h"
#import "KalDayAnnotations.h"
#import "KalCheckBox.h"

@interface KalDayTileView ()

- (void)updateStyle;

@end

@implementation KalDayTileView

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		self.opaque = YES;
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor lightGrayColor];
		[self resetState];

		backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:backgroundImageView];

		annotationView = [[KalAnnotationView alloc] initWithFrame:CGRectZero];
		[self addSubview:annotationView];
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 1, frame.size.width-3, 15)];
		dateLabel.font = [UIFont boldSystemFontOfSize:12.f];
		dateLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:dateLabel];
		
		checkbox = [[KalCheckBox alloc] initWithFrame:self.bounds];
		[self addSubview:checkbox];

		[self updateStyle];
	}
	return self;
}

- (void)resetState
{
	[date release];
	date = nil;
	flags.type = KalTileTypeRegular;
	flags.selected = NO;
	flags.showCheckbox = NO;
	[self updateStyle];
}

- (void)layoutSubviews
{
	backgroundImageView.frame = self.bounds;
	annotationView.frame = CGRectMake(5, 15, self.bounds.size.width - 10, self.bounds.size.height - 20);
	dateLabel.frame = CGRectMake(3, 1, self.bounds.size.width-3, 15);
	checkbox.frame = self.bounds;
	
	[annotationView setNeedsDisplay];
}

- (void)updateStyle
{
	if ([self isToday] && self.selected) {
//		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile_today_selected.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:20];
//		dateLabel.textColor = [UIColor whiteColor];
//		dateLabel.shadowColor = [UIColor blackColor];
//		dateLabel.shadowOffset = CGSizeMake(0, 1);
	} else if ([self isToday] && !self.selected) {
		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile_today.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:20];
		dateLabel.textColor = [UIColor whiteColor];
		dateLabel.shadowColor = [UIColor blackColor];
		dateLabel.shadowOffset = CGSizeMake(0, 1);
	} else if (self.selected) {
//		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:20];
//		dateLabel.textColor = [UIColor whiteColor];
//		dateLabel.shadowColor = [UIColor blackColor];
//		dateLabel.shadowOffset = CGSizeMake(0, -1);
	} else if (self.belongsToAdjacentMonth) {
		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
		dateLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_dim_text_fill.png"]];
		dateLabel.shadowColor = nil;
		dateLabel.shadowOffset = CGSizeZero;
	} else {
		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
//		dateLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_text_fill.png"]];
		dateLabel.textColor = [UIColor blackColor];
		dateLabel.shadowColor = [UIColor whiteColor];
		dateLabel.shadowOffset = CGSizeMake(0, 1);
	}
	
	checkbox.hidden = !flags.showCheckbox;
}

- (void)setDate:(KalDate *)aDate
{
	if (date == aDate)
		return;
	
	[date release];
	date = [aDate retain];
	
	NSUInteger n = [self.date day];
	NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
	dateLabel.text = dayText;
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
	if (flags.selected == selected)
		return;
	
	flags.selected = selected;
	checkbox.checked = selected;
	[self updateStyle];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
	if (flags.type == tileType)
		return;
	flags.type = tileType;
	
	[self updateStyle];
}

- (BOOL)isShowingCheckbox { return flags.showCheckbox; }

- (void)setShowCheckbox:(BOOL)showCheckbox
{
	NSLog(@"%i", showCheckbox);
	if (flags.showCheckbox == showCheckbox) {
		return;
	}
	flags.showCheckbox = showCheckbox;
	checkbox.checked = NO;
	[self updateStyle];
}

- (void)setDayAnnotations:(KalDayAnnotations *)annotations
{
	// set annotations for view
	annotationView.dayAnnotations = annotations;
	[annotationView setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }

- (void)dealloc
{
	[date release];
	[dateLabel release];
	[backgroundImageView release];
	[annotationView release];
	[checkbox release];
	[super dealloc];
}

@end
