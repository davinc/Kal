/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDayTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"

@interface KalDayTileView ()

- (void)updateStyle;

@end

@implementation KalDayTileView

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = NO;
		[self resetState];

		backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:backgroundImageView];

		dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 1, frame.size.width-3, 15)];
		dateLabel.font = [UIFont boldSystemFontOfSize:12.f];
		dateLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:dateLabel];
		
		[self updateStyle];
	}
	return self;
}

- (void)resetState
{
	[date release];
	date = nil;
	flags.type = KalTileTypeRegular;
	flags.highlighted = NO;
	flags.selected = NO;
	flags.marked = NO;
	[self updateStyle];
}

- (void)layoutSubviews
{
	backgroundImageView.frame = self.bounds;
	dateLabel.frame = CGRectMake(3, 1, self.bounds.size.width-3, 15);
}

- (void)updateStyle
{
	if ([self isToday] && self.selected) {
		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile_today_selected.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:20];
		dateLabel.textColor = [UIColor whiteColor];
		dateLabel.shadowColor = [UIColor blackColor];
		dateLabel.shadowOffset = CGSizeMake(0, 1);
	} else if ([self isToday] && !self.selected) {
		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile_today.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:20];
		dateLabel.textColor = [UIColor whiteColor];
		dateLabel.shadowColor = [UIColor blackColor];
		dateLabel.shadowOffset = CGSizeMake(0, 1);
	} else if (self.selected) {
		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:20];
		dateLabel.textColor = [UIColor whiteColor];
		dateLabel.shadowColor = [UIColor blackColor];
		dateLabel.shadowOffset = CGSizeMake(0, -1);
	} else if (self.belongsToAdjacentMonth) {
		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
		dateLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_dim_text_fill.png"]];
		dateLabel.shadowColor = nil;
		dateLabel.shadowOffset = CGSizeZero;
	} else {
		backgroundImageView.image = [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
		dateLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_text_fill.png"]];
		dateLabel.shadowColor = [UIColor whiteColor];
		dateLabel.shadowOffset = CGSizeMake(0, 1);
	}
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
	[self updateStyle];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
	if (flags.highlighted == highlighted)
		return;
	
	flags.highlighted = highlighted;
	[self updateStyle];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
	if (flags.marked == marked)
		return;
	
	flags.marked = marked;
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

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }

- (void)dealloc
{
	[date release];
	[dateLabel release];
	[backgroundImageView release];
	[super dealloc];
}

@end
