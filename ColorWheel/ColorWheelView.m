//
//  ColorWheelView.m
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ColorWheelView.h"
#import "Constants.h"

@interface ColorWheelView ()

@property (strong, nonatomic) NSArray *colors;

@property (nonatomic) CGPoint circleCenter;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat pieHeight;

@end

@implementation ColorWheelView

-(instancetype)initWithColors:(NSArray *)colors {
  self = [super init];
  if (self) {
    self.colors = colors;
  }
  return self;
}

-(instancetype)initWithDelegate:(id <ColorWheelDelegate>)delegate {
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.delegate = delegate;
    self.colors = delegate.colors;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  self.circleCenter = CGPointMake(rect.size.width/2, rect.size.height/2);
  self.pieHeight = MIN(rect.size.width, rect.size.height) / 2;
  self.radius = self.pieHeight/2;
  
  CGFloat pieAngle = kFullCircleInRadians / (CGFloat)self.colors.count;
  
  for (int i = 0; i < self.colors.count; i++) {
    CGFloat zeroPointToTopCenterOffset = -kFullCircleInRadians/4;
    CGFloat centerAngle = pieAngle * (CGFloat)i + zeroPointToTopCenterOffset;
    CGFloat startAngle = centerAngle - pieAngle/2;
    CGFloat endAngle = centerAngle + pieAngle/2;
    
    [self drawPieWithColor:self.colors[i] withStartAngle:startAngle endAngle:endAngle];
  }
}

#pragma mark - Helper Methods

-(void)drawPieWithColor:(UIColor *)color withStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
  UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.circleCenter radius:self.radius startAngle:startAngle endAngle:endAngle clockwise:true];
  
  [color setStroke];
  path.lineWidth = self.pieHeight;
  [path stroke];
}

#pragma mark - Getters/Setters

-(NSArray *)colors {
  if (!_colors) {
    _colors = [[NSArray alloc] init];
  }
  return _colors;
}

@end
