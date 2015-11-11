//
//  ColorWheelDelegate.h
//  ColorWheel
//
//  Created by Chris Budro on 11/11/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColorWheelView;

@protocol ColorWheelDelegate <NSObject>

@property (nonatomic) NSArray *colors;
@property (readonly, nonatomic) CGFloat pieAngle;
-(NSInteger)colorWheel:(ColorWheelView *)colorWheel adjustedIndexForAngle:(CGFloat)angle;
-(CGFloat)angleForIndex:(NSInteger)index;
-(void)colorWheel:(ColorWheelView *)colorWheel spinToColorAtIndex:(NSInteger)index;

@end

@interface ColorWheelDelegate : NSObject <ColorWheelDelegate>

@property (nonatomic) NSArray *colors;
@property (readonly, nonatomic) CGFloat pieAngle;

-(instancetype)initWithColors:(NSArray *)colors;

@end
