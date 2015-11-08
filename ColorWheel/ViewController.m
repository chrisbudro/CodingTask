//
//  ViewController.m
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ViewController.h"
#import "ColorWheelView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ColorWheelView *colorWheelView;
@property (strong, nonatomic) UIPanGestureRecognizer *wheelPanGesture;

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGAffineTransform startTransform;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  [self.colorWheelView addGestureRecognizer:self.wheelPanGesture];
}

#pragma mark - Helper Methods

-(void)handleSpin:(UIPanGestureRecognizer *)spinGesture {
  CGPoint touchPoint = [spinGesture translationInView:self.view];
  
  //  NSLog(@"bounds: %f, %f", , self.bounds.size.height/2);
  
  CGFloat xFromCenter = touchPoint.x - self.colorWheelView.center.x;
  CGFloat yFromCenter = touchPoint.y - self.colorWheelView.center.y;
  
  if (spinGesture.state == UIGestureRecognizerStateBegan) {
    self.startAngle = atan2(yFromCenter, xFromCenter);
    self.startTransform = self.colorWheelView.transform;
  }
  
  if (spinGesture.state == UIGestureRecognizerStateChanged) {
    CGFloat newAngle = atan2(yFromCenter, xFromCenter);
    
    
    CGFloat angleDifference = self.startAngle - newAngle;
    
    NSLog(@"%f, %f, %f", angleDifference, newAngle, self.startAngle);
    
    self.colorWheelView.transform = CGAffineTransformRotate(self.startTransform, angleDifference);
  }
}



#pragma mark - Custom Getters/Setters

-(UIPanGestureRecognizer *)wheelPanGesture {
  if (!_wheelPanGesture) {
    _wheelPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpin:)];
  }
  return _wheelPanGesture;
}


@end
