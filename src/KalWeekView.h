//
//  KalWeekView.h
//  Kal
//
//  Created by Vinay Chavan on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KalDayTileView, KalDate;

@interface KalWeekView : UIView
{
	UILabel *headerLabel;
	UIImageView *headerBackgroundImageView;
	NSMutableArray *dayTiles;
}

@property (nonatomic) NSInteger weekIndex;
@property (nonatomic, readonly) NSArray *dayTiles;

- (void)setTitleText:(NSString *)text;

@end
