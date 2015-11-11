//
//  CBSpinnerWheel.h
//  ColorWheel
//
//  Created by Chris Budro on 11/8/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBSpinnerWheel;

@protocol CBSpinnerWheelDelegate <NSObject>

-(void)spinner:(CBSpinnerWheel *)spinner didSelectColorAtIndex:(NSInteger)index;

@end

@interface CBSpinnerWheel : UIView

@property (weak, nonatomic) id <CBSpinnerWheelDelegate> delegate;

-(void)selectColorAtIndex:(NSInteger)index;

@end
