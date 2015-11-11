//
//  CBSpinnerWheel.m
//  ColorWheel
//
//  Created by Chris Budro on 11/8/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "CBSpinnerWheel.h"
#import "ColorWheelView.h"
#import "Colors.h"
#import "SpinGestureRecognizer.h"

CGFloat const kSnapToPieAnimationDuration = 0.4;

@interface CBSpinnerWheel ()


@property (strong, nonatomic) SpinGestureRecognizer *spinGesture;

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGAffineTransform startTransform;
@property (readonly, nonatomic) CGFloat pieAngle;

@property (nonatomic) NSInteger currentIndex;

@end

@implementation CBSpinnerWheel

#pragma mark - Life Cycle Methods

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setupContentView];
    [self addGestureRecognizer:self.spinGesture];
    [self offsetSelectedPiePieceToTopCenter];
    [self selectColorAtIndex:self.currentIndex];
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

#pragma mark - Helper Methods

-(void)setupContentView {
  self.contentView = [[ColorWheelView alloc] initWithColors:[[Colors shared] colorList]];
  self.contentView.backgroundColor = [UIColor clearColor];
  [self addSubview:self.contentView];
  
  self.contentView.translatesAutoresizingMaskIntoConstraints = false;
  NSDictionary *views = @{@"contentView": self.contentView};
  NSArray *verticalContentConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
  NSArray *horizontalContentConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[contentView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
  
  [self addConstraints:verticalContentConstraints];
  [self addConstraints:horizontalContentConstraints];
}

-(void)offsetSelectedPiePieceToTopCenter {
  CGFloat quarterRotationNegativeOffset = -M_PI/2;
  CGAffineTransform topCenterOffset = CGAffineTransformRotate(self.transform, quarterRotationNegativeOffset);
  self.transform = topCenterOffset;
}

-(void)handleSpin:(SpinGestureRecognizer *)spinGesture {

  switch (spinGesture.state) {
    case UIGestureRecognizerStateEnded:
    {
      CGFloat currentAngle = [spinGesture currentRotationAngle];
      NSInteger newIndex = [self adjustedIndexForAngle:currentAngle];
      [self selectColorAtIndex:newIndex];
      NSLog(@"new index: %ld", newIndex);
    }
      break;
    default:
      break;
  }
}

-(NSInteger)adjustedIndexForAngle:(CGFloat)angle {
  NSInteger calculatedIndex = 0;
  if (angle <= 0) {
    calculatedIndex = fabs(round(angle / self.pieAngle));
  } else {
    CGFloat correctedAngle = 2*M_PI - angle;
    calculatedIndex = round(correctedAngle / self.pieAngle);
    if (calculatedIndex >= [[Colors shared] colorList].count) {
      calculatedIndex = 0;
    }
  }
  return calculatedIndex;
}

-(CGFloat)angleForIndex:(NSInteger)index {
  CGFloat adjustedAngle = index * self.pieAngle;
  if (adjustedAngle > M_PI) {
    adjustedAngle = 2*M_PI - adjustedAngle;
  } else {
    adjustedAngle = -adjustedAngle;
  }
  return adjustedAngle;
}

-(void)setNewIndex:(NSInteger)index {
  if (self.currentIndex != index) {
    self.currentIndex = index;
    [self.delegate spinner:self didSelectColorAtIndex:self.currentIndex];
  }
}

-(void)selectColorAtIndex:(NSInteger)index {
  [self setNewIndex:index];
  
  CGFloat adjustedAngle = [self angleForIndex:index];
  CGFloat angleCorrection = self.spinGesture.currentRotationAngle - adjustedAngle;

  CGAffineTransform rotateToCenterOfPie = CGAffineTransformRotate(self.transform, -angleCorrection);
  
  [UIView animateWithDuration:kSnapToPieAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.transform = rotateToCenterOfPie;
    
  } completion:nil];
}

//-(CGFloat)distanceFromCenter:(CGPoint)point {
//  CGFloat x = point.x - self.bounds.size.width/2;
//  CGFloat y = point.y - self.bounds.size.height/2;
//
//  return hypotf(x, y);
//}

#pragma mark - Getters/Setters

//-(UIPanGestureRecognizer *)spinGesture {
//  if (!_spinGesture) {
//    _spinGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpin:)];
//  }
//  return _spinGesture;
//}

-(SpinGestureRecognizer *)spinGesture {
  if (!_spinGesture) {
    _spinGesture = [[SpinGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpin:)];
  }
  return _spinGesture;
}

-(void)setCurrentIndex:(NSInteger)currentIndex {
  [[Colors shared] updateCurrentIndex:currentIndex];
}

-(NSInteger)currentIndex {
  return [Colors shared].currentIndex;
}

-(CGFloat)pieAngle {
  CGFloat colorCount = [[Colors shared] colorList].count;
  return (2*M_PI) / colorCount;
}

@end
