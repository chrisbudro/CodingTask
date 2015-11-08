//
//  CBSpinnerWheel.m
//  ColorWheel
//
//  Created by Chris Budro on 11/8/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "CBSpinnerWheel.h"

@interface CBSpinnerWheel ()

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGAffineTransform startTransform;

@end

@implementation CBSpinnerWheel

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  if (self) {
//    [self addGestureRecognizer:self.spinGesture];
  }
  return self;
}

//-(void)handleSpin:(UIPanGestureRecognizer *)spinGesture {
//  CGPoint touchDownPoint = [spinGesture translationInView:self];
//  CGPoint touchPoint = [spinGesture locationInView:self];
//
//  CGFloat xFromCenter = touchPoint.x - self.bounds.size.width/2;
//  CGFloat yFromCenter = touchPoint.y - self.bounds.size.height/2;
//
//
//  if (spinGesture.state == UIGestureRecognizerStateBegan) {
//    self.startAngle = atan2(yFromCenter, xFromCenter);
//    self.startTransform = self.transform;
//  }
//  
//  if (spinGesture.state == UIGestureRecognizerStateChanged) {
//    CGFloat radians = atan2f(self.transform.b, self.transform.a);
////    NSLog(@"Radians: %f", radians);
//    
//    CGFloat newAngle = atan2(yFromCenter, xFromCenter);
//    
//    CGFloat angleDifference = self.startAngle - newAngle;
//    
//    NSLog(@"%f, %f, %f", angleDifference, newAngle, self.startAngle);
//    
//    self.transform = CGAffineTransformRotate(self.startTransform, -angleDifference);
//  }
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self];
  
  CGFloat xFromCenter = touchPoint.x - self.bounds.size.width/2;
  CGFloat yFromCenter = touchPoint.y - self.bounds.size.height/2;
  
  self.startAngle = atan2(yFromCenter, xFromCenter);
  self.startTransform = self.transform;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

  
  UITouch *touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self];
  
  CGFloat distance = [self distanceFromCenter:touchPoint];
  
  if (distance > 40) {
    CGFloat xFromCenter = touchPoint.x - self.bounds.size.width/2;
    CGFloat yFromCenter = touchPoint.y - self.bounds.size.height/2;
    
    CGFloat newAngle = atan2(yFromCenter, xFromCenter);
    CGFloat angleDifference = self.startAngle - newAngle;
    
    self.transform = CGAffineTransformRotate(self.startTransform, -angleDifference);
  }
}

-(CGFloat)distanceFromCenter:(CGPoint)point {
  CGFloat x = point.x - self.bounds.size.width/2;
  CGFloat y = point.y - self.bounds.size.height/2;

  return hypotf(x, y);
}

#pragma mark - Custom Getters/Setters

-(UIPanGestureRecognizer *)spinGesture {
  if (!_spinGesture) {
    _spinGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpin:)];
  }
  return _spinGesture;
}

@end
