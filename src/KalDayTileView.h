/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

enum {
	KalTileTypeRegular   = 0,
	KalTileTypeAdjacent  = 1 << 0,
	KalTileTypeToday     = 1 << 1,
};
typedef char KalTileType;

@class KalDate;
@class KalAnnotationView;
@class KalDayAnnotations;
@class KalCheckBox;

@interface KalDayTileView : UIView
{
	KalDate *date;
	UIImageView *backgroundImageView;
	UILabel *dateLabel;
	KalAnnotationView *annotationView;
	KalCheckBox *checkbox;
	struct {
		unsigned int selected : 1;
		unsigned int showCheckbox : 1;
		unsigned int type : 2;
	} flags;
}

@property (nonatomic, retain) KalDate *date;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isShowingCheckbox) BOOL showCheckbox;
@property (nonatomic) KalTileType type;

- (void)resetState;
- (void)setDayAnnotations:(KalDayAnnotations *)annotations;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;

@end
