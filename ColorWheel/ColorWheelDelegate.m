//
//  ColorWheelDelegate.m
//  ColorWheel
//
//  Created by Chris Budro on 11/11/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ColorWheelDelegate.h"
#import "ColorWheelView.h"

CGFloat const kSnapToPieAnimationDuration = 0.4;
CGFloat const kSnapToPieAnimationDamping = 0.6;
CGFloat const kSnapToPieAnimationInitialVelocity = 0.4;

@implementation ColorWheelDelegate

-(instancetype)initWithColors:(NSArray *)colors {
  self = [super init];
  if (self) {
    self.colors = colors;
  }
  return self;
}

#pragma mark - Color Wheel Delegate

-(NSInteger)colorWheel:(ColorWheelView *)colorWheel adjustedIndexForAngle:(CGFloat)angle {
  NSInteger calculatedIndex = 0;
  if (angle <= 0) {
    calculatedIndex = fabs(round(angle / self.pieAngle));
  } else {
    CGFloat correctedAngle = kFullCircleInRadians - angle;
    calculatedIndex = round(correctedAngle / self.pieAngle);
    if (calculatedIndex >= self.colors.count) {
      calculatedIndex = 0;
    }
  }
  return calculatedIndex;
}

-(void)colorWheel:(ColorWheelView *)colorWheel spinToColorAtIndex:(NSInteger)index {

  CGFloat adjustedAngleForNewIndex = [self angleForIndex:index];
  CGFloat currentRotationAngle = atan2(colorWheel.transform.b, colorWheel.transform.a);
  CGFloat angleCorrection = currentRotationAngle - adjustedAngleForNewIndex;
  
  CGAffineTransform rotateToCenterOfPie = CGAffineTransformRotate(colorWheel.transform, -angleCorrection);
  
  [UIView animateWithDuration:kSnapToPieAnimationDuration delay:0 usingSpringWithDamping:kSnapToPieAnimationDamping initialSpringVelocity:kSnapToPieAnimationInitialVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
    colorWheel.transform = rotateToCenterOfPie;
    
  } completion:nil];
}

-(CGFloat)angleForIndex:(NSInteger)index {
  CGFloat adjustedAngle = index * self.pieAngle;
  if (adjustedAngle > M_PI) {
    adjustedAngle = kFullCircleInRadians - adjustedAngle;
  } else {
    adjustedAngle = -adjustedAngle;
  }
  return adjustedAngle;
}

#pragma mark - Getters/Setters

-(CGFloat)pieAngle {
  return kFullCircleInRadians / self.colors.count;
}



@end
