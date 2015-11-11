//
//  SpinGestureRecognizer.m
//  ColorWheel
//
//  Created by Chris Budro on 11/10/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "SpinGestureRecognizer.h"
#import "ColorWheelView.h"
#import "CBSpinnerWheel.h"

@interface SpinGestureRecognizer ()

@property (nonatomic) CGFloat startAngle;
//@property (nonatomic) CGAffineTransform startTransform;

@end

@implementation SpinGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  if (touches.count != 1) {
    self.state = UIGestureRecognizerStateFailed;
    return;
  }
  
  CGPoint touchPoint = [touches.anyObject locationInView:self.view];
  
  CGFloat xFromCenter = touchPoint.x - self.view.bounds.size.width/2;
  CGFloat yFromCenter = touchPoint.y - self.view.bounds.size.height/2;
  
  self.startAngle = atan2(yFromCenter, xFromCenter);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  if (self.state == UIGestureRecognizerStateFailed) return;
  
  CGPoint touchPoint = [touches.anyObject locationInView:self.view];

  CGFloat xFromCenter = touchPoint.x - self.view.bounds.size.width/2;
  CGFloat yFromCenter = touchPoint.y - self.view.bounds.size.height/2;
  
  CGFloat newAngle = atan2(yFromCenter, xFromCenter);
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
//  self.startTransform = CGAffineTransformIdentity;
  self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
  [super reset];
  self.startAngle = 0;
//  self.startTransform = CGAffineTransformIdentity;
}

@end
