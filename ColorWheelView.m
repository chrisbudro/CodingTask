//
//  ColorWheelView.m
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ColorWheelView.h"

CGFloat const totalDegrees = 360;

@interface ColorWheelView ()

@property (nonatomic) CGPoint circleCenter;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat pieHeight;

@end

@implementation ColorWheelView

//- (void)drawRect:(CGRect)rect {
//  self.circleCenter = CGPointMake(rect.size.width/2, rect.size.height/2);
//  self.radius = MAX(rect.size.width, rect.size.height) / 2;
//  self.pieHeight = self.radius - self.radius/2;
//  
//  CGFloat pieAngle = totalDegrees / (CGFloat)self.colors.count;
//  
//  for (int i = 0; i < self.colors.count; i++) {
//    CGFloat startAngle = pieAngle * (CGFloat)i;
//    CGFloat endAngle = startAngle + pieAngle;
//    
//    [self drawPieWithColor:self.colors[i] withStartAngleInDegrees:startAngle endAngleInDegrees:endAngle];
//  }
//}

- (void)drawRect:(CGRect)rect {
  self.circleCenter = CGPointMake(rect.size.width/2, rect.size.height/2);
  NSLog(@"rect center: %f, %f", self.circleCenter.x, self.circleCenter.y);
  self.radius = MAX(rect.size.width, rect.size.height) / 2;
  self.pieHeight = self.radius - self.radius/2;
  
  CGFloat pieAngle = 2*M_PI / (CGFloat)self.colors.count;
  
  for (int i = 0; i < self.colors.count; i++) {
    CGFloat startAngle = pieAngle * (CGFloat)i;
    CGFloat endAngle = startAngle + pieAngle;
    
    [self drawPieWithColor:self.colors[i] withStartAngle:startAngle endAngle:endAngle];
  }
}

-(void)drawPieWithColor:(UIColor *)color withStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
  UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.circleCenter radius:self.pieHeight startAngle:startAngle endAngle:endAngle clockwise:true];
  
  [color setStroke];
  path.lineWidth = self.radius;
  [path stroke];
}

//-(instancetype)initWithCoder:(NSCoder *)aDecoder {
//  self = [super initWithCoder:aDecoder];
//  if (self) {
//    [self drawColorWheel];
//  }
//  return self;
//}

#pragma mark - Helper Methods

//-(void)drawColorWheel {
//  
//  UIGraphicsBeginImageContext(self.bounds.size);
//  CGContextRef context = UIGraphicsGetCurrentContext();
//  
//  self.circleCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//  self.radius = MAX(self.bounds.size.width, self.bounds.size.height) / 2;
//  self.pieHeight = self.radius - self.radius/2;
//  
//  NSLog(@"Bounds: %f, %f, screen: %f, %f", self.frame.size.width, self.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//  
//  CGFloat pieAngle = totalDegrees / (CGFloat)self.colors.count;
//  
//  for (int i = 0; i < self.colors.count; i++) {
//    CGFloat startAngle = pieAngle * (CGFloat)i;
//    CGFloat endAngle = startAngle + pieAngle;
//    
//    [self drawPieWithColor:self.colors[i] withStartAngleInDegrees:startAngle endAngleInDegrees:endAngle inContext:context];
//  }
//  UIGraphicsEndImageContext();
//}

//-(void)drawPieWithColor:(UIColor *)color withStartAngleInDegrees:(CGFloat)startAngle endAngleInDegrees:(CGFloat)endAngle inContext:(CGContextRef)context {
//  UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.circleCenter radius:self.pieHeight startAngle:[self radiansFromDegrees:startAngle] endAngle:[self radiansFromDegrees:endAngle] clockwise:true];
//  
//  CGContextAddPath(context, path.CGPath);
//  CGContextSetStrokeColorWithColor(context, color.CGColor);
//  CGContextSetLineWidth(context, self.radius);
//  
//  CGContextDrawPath(context, kCGPathFillStroke);
//}

-(void)drawPieWithColor:(UIColor *)color withStartAngleInDegrees:(CGFloat)startAngle endAngleInDegrees:(CGFloat)endAngle {
  UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.circleCenter radius:self.pieHeight startAngle:[self radiansFromDegrees:startAngle] endAngle:[self radiansFromDegrees:endAngle] clockwise:true];
  
  [color setStroke];
  path.lineWidth = self.radius;
  [path stroke];
}

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


-(CGFloat)radiansFromDegrees:(CGFloat)degrees {
  return degrees * M_PI/180.0;
}

-(CGFloat)degreesFromRadians:(CGFloat)radians {
  return radians * (180.0/M_PI);
}

#pragma mark - Custom Getters/Setters

-(NSArray *)colors {
  if (!_colors) {
    _colors = @[[UIColor blueColor], [UIColor redColor], [UIColor yellowColor]];
  }
  return _colors;
}


@end
