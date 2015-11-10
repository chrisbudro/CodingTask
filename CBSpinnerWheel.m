//
//  CBSpinnerWheel.m
//  ColorWheel
//
//  Created by Chris Budro on 11/8/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "CBSpinnerWheel.h"
#import "ColorWheelView.h"
#import "PiePiece.h"
#import "Colors.h"

CGFloat const kSnapToPieAnimationDuration = 0.2;

@interface CBSpinnerWheel ()

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic) ColorWheelView *contentView;
@property (nonatomic) NSMutableArray *piePieces;
@property (readonly, nonatomic) CGFloat pieAngle;
@property (strong, nonatomic) UIPanGestureRecognizer *spinGesture;
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
    [self registerPiePieces];
    
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupContentView];
    [self addGestureRecognizer:self.spinGesture];
    [self offsetSelectedPiePieceToTopCenter];
    
    [self registerPiePieces];
    
    [self selectColorAtIndex:self.currentIndex];
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
  CGFloat centerPiePieceOffset = self.pieAngle/2;
  CGFloat offset = quarterRotationNegativeOffset - centerPiePieceOffset;
  
  CGAffineTransform topCenterOffset = CGAffineTransformRotate(self.transform, offset);
  self.transform = topCenterOffset;
}

-(void)registerPiePieces {
  NSArray *colors = [[Colors shared] colorList];
  self.piePieces = [NSMutableArray arrayWithCapacity:colors.count];
  
  CGFloat centerValue = 0;
  
  for (int i = 0; i < colors.count; i++) {
    PiePiece *pie = [[PiePiece alloc] init];
    pie.centerValue = centerValue;
    pie.minValue = centerValue - self.pieAngle/2;
    pie.maxValue = centerValue + self.pieAngle/2;
    pie.index = i;
    
    if (colors.count % 2 == 0 && pie.maxValue - self.pieAngle < -M_PI) {
      centerValue = M_PI;
      pie.centerValue = centerValue;
      pie.minValue = fabs(pie.maxValue);
    }
    
    centerValue -= self.pieAngle;
    
    if (colors.count % 2 != 0 && pie.minValue <= -M_PI) {
      centerValue = -centerValue;
      centerValue -= self.pieAngle;
    }
    [self.piePieces addObject:pie];
  }
}

-(void)handleSpin:(UIPanGestureRecognizer *)spinGesture {
  CGPoint touchPoint = [spinGesture locationInView:self];

  CGFloat xFromCenter = touchPoint.x - self.contentView.bounds.size.width/2;
  CGFloat yFromCenter = touchPoint.y - self.contentView.bounds.size.height/2;

  switch (spinGesture.state) {
    case UIGestureRecognizerStateBegan:
      self.startAngle = atan2(yFromCenter, xFromCenter);
      self.startTransform = self.contentView.transform;
      break;
    case UIGestureRecognizerStateChanged:
    {
      CGFloat newAngle = atan2(yFromCenter, xFromCenter);
      CGFloat angleDifference = self.startAngle - newAngle;
      NSLog(@"start: %f, new: %f, diff: %f", self.startAngle, newAngle, angleDifference);
      self.contentView.transform = CGAffineTransformRotate(self.startTransform, -angleDifference);
      break;
    }
    case UIGestureRecognizerStateEnded:
    {
      CGFloat currentAngle = atan2f(self.contentView.transform.b, self.contentView.transform.a);
      CGFloat newValue = 0.0;
      
      NSInteger updatedIndex = 0;
      for (PiePiece *pie in self.piePieces) {
        if (pie.minValue > 0 && pie.maxValue < 0) {
          if (pie.maxValue > currentAngle || pie.minValue < currentAngle) {
            if (currentAngle > 0) {
              newValue = currentAngle - M_PI;
            } else {
              newValue = M_PI + currentAngle;
            }
            updatedIndex = pie.index;
            break;
          }
        } else if (currentAngle > pie.minValue && currentAngle < pie.maxValue) {
          newValue = currentAngle - pie.centerValue;
          updatedIndex = pie.index;
          break;
        }
      }
      
      if (self.currentIndex != updatedIndex) {
        self.currentIndex = updatedIndex;
        [self.delegate spinner:self didSelectColorAtIndex:self.currentIndex];
      }
      
      CGAffineTransform rotateToCenterOfPie = CGAffineTransformRotate(self.contentView.transform, -newValue);
      [UIView animateWithDuration:kSnapToPieAnimationDuration animations:^{
        self.contentView.transform = rotateToCenterOfPie;
      }];
    }
      break;
    default:
      break;
  }
}

-(void)selectColorAtIndex:(NSInteger)index {
  
  CGFloat currentAngle = atan2f(self.contentView.transform.b, self.contentView.transform.a);
  CGFloat newAngle = index * self.pieAngle;
  CGFloat angleDifference = currentAngle + newAngle;

  CGAffineTransform rotationToNewIndex = CGAffineTransformRotate(self.contentView.transform, -angleDifference);
  [UIView animateWithDuration:kSnapToPieAnimationDuration animations:^{
    self.contentView.transform = rotationToNewIndex;
  }];
  
  self.currentIndex = index;
}

//-(CGFloat)distanceFromCenter:(CGPoint)point {
//  CGFloat x = point.x - self.bounds.size.width/2;
//  CGFloat y = point.y - self.bounds.size.height/2;
//
//  return hypotf(x, y);
//}

#pragma mark - Getters/Setters

-(UIPanGestureRecognizer *)spinGesture {
  if (!_spinGesture) {
    _spinGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpin:)];
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

-(CGFloat)degreesFromRadians:(CGFloat)radians {
  return radians * (180.0/M_PI);
}

-(CGFloat)radiansFromDegrees:(CGFloat)degrees {
  return (M_PI/180.0)*degrees;
}



@end
