//
//  ColorWheelView.m
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ColorWheelView.h"
#import "PiePiece.h"
#import "Colors.h"

@interface ColorWheelView ()

@property (nonatomic) CGPoint circleCenter;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat pieHeight;

@end

@implementation ColorWheelView

-(instancetype)init {
  self = [super init];
  if (self) {
    [self registerPiePieces];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  self.circleCenter = CGPointMake(rect.size.width/2, rect.size.height/2);
  self.radius = MAX(rect.size.width, rect.size.height) / 2;
  self.pieHeight = self.radius - self.radius/2;
  
  CGFloat pieAngle = 2*M_PI / (CGFloat)self.colors.count;
  
  for (int i = 0; i < self.colors.count; i++) {
    CGFloat startAngle = pieAngle * (CGFloat)i;
    CGFloat endAngle = startAngle + pieAngle;
    
    [self drawPieWithColor:self.colors[i] withStartAngle:startAngle endAngle:endAngle];
  }
}

#pragma mark - Helper Methods

-(void)drawPieWithColor:(UIColor *)color withStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
  UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.circleCenter radius:self.pieHeight startAngle:startAngle endAngle:endAngle clockwise:true];
  
  [color setStroke];
  path.lineWidth = self.radius;
  [path stroke];
}

-(void)registerPiePieces {
  self.piePieces = [NSMutableArray arrayWithCapacity:self.colors.count];
  CGFloat pieAngle = 2*M_PI / (CGFloat)self.colors.count;
  
  CGFloat centerValue = 0;
  
  for (int i = 0; i < self.colors.count; i++) {
    PiePiece *pie = [[PiePiece alloc] init];
    pie.centerValue = centerValue;
    pie.minValue = centerValue - pieAngle/2;
    pie.maxValue = centerValue + pieAngle/2;
    pie.index = i;
    
    if (self.colors.count % 2 == 0 && pie.maxValue - pieAngle < -M_PI) {
      centerValue = M_PI;
      pie.centerValue = centerValue;
      pie.minValue = fabs(pie.maxValue);
    }
    
    centerValue -= pieAngle;
    
    if (self.colors.count % 2 != 0 && pie.minValue <= -M_PI) {
      centerValue = -centerValue;
      centerValue -= pieAngle;
    }
    [self.piePieces addObject:pie];
  }
}

-(CGFloat)distanceFromCenter:(CGPoint)point {
  CGFloat x = point.x - self.bounds.size.width/2;
  CGFloat y = point.y - self.bounds.size.height/2;
  
  return hypotf(x, y);
}

#pragma mark - Custom Getters/Setters

-(NSArray *)colors {
  if (!_colors) {
    _colors = [[Colors shared] colorList];
  }
  return _colors;
}

@end
