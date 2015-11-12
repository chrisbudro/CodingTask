//
//  SpinGestureRecognizer.m
//  ColorWheel
//
//  Created by Chris Budro on 11/10/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "SpinGestureRecognizer.h"

@interface SpinGestureRecognizer ()

@property (nonatomic) CGFloat startAngle;

@end

@implementation SpinGestureRecognizer

#pragma mark - Gesture Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  if (touches.count != 1) {
    self.state = UIGestureRecognizerStateFailed;
    return;
  }
  
  CGPoint touchPoint = [touches.anyObject locationInView:self.view];
  self.startAngle = [self angleFromCenterToPoint:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  if (self.state == UIGestureRecognizerStateFailed) return;
  
  CGPoint touchPoint = [touches.anyObject locationInView:self.view];
  CGFloat newAngle = [self angleFromCenterToPoint:touchPoint];
  CGFloat angleDifference = self.startAngle - newAngle;
  self.view.transform = CGAffineTransformRotate(self.view.transform, -angleDifference);
  
  self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  if (self.state == UIGestureRecognizerStatePossible) {
    self.state = UIGestureRecognizerStateRecognized;
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  self.startAngle = 0;
  self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
  [super reset];
  self.startAngle = 0;
}

#pragma mark - Helper Methods

-(CGFloat)angleFromCenterToPoint:(CGPoint)point {
  CGPoint centerPoint = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
  CGFloat xFromCenter = point.x - centerPoint.x;
  CGFloat yFromCenter = point.y - centerPoint.y;
  return atan2(yFromCenter, xFromCenter);
}

-(CGFloat)currentRotationAngle {
  return atan2f(self.view.transform.b, self.view.transform.a);
}

@end
