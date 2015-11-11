//
//  ViewController.m
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "ColorWheelView.h"
#import "Constants.h"
#import "Colors.h"
#import "SpinGestureRecognizer.h"
#import "ColorWheelDelegate.h"

CGFloat const kColorWheelToSuperViewMultiplier = 0.80;

@interface ViewController () <WCSessionDelegate>


@property (weak, nonatomic) IBOutlet ColorWheelView *colorWheelView;
@property (strong, nonatomic) WCSession *session;
@property (strong, nonatomic) SpinGestureRecognizer *spinGesture;
@property (strong, nonatomic) id <ColorWheelDelegate> colorWheelDelegate;

@end

@implementation ViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupColorWheel];
  [self setupWatchConnectivitySession];
  [self setupUI];
}

#pragma mark - Helper Methods

-(void)setupWatchConnectivitySession {
  self.session = [WCSession defaultSession];
  self.session.delegate = self;
  [self.session activateSession];
  
  if (self.session.reachable) {
    [self sendColorIndexToWatch:[Colors shared].currentIndex];
  }
}

-(void)setupColorWheel {
  self.spinGesture = [[SpinGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpin:)];
  [self.colorWheelView addGestureRecognizer:self.spinGesture];
  self.colorWheelDelegate = [[ColorWheelDelegate alloc] initWithColors:[[Colors shared] colorList]];
  self.colorWheelView.delegate = self.colorWheelDelegate;
}

-(void)setupColorWheelConstraints {
  NSLayoutConstraint *scaleConstraint;
  if ([self isLandscapeOrientation]) {
    scaleConstraint = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:kColorWheelToSuperViewMultiplier constant:0];
  } else {
    scaleConstraint = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:kColorWheelToSuperViewMultiplier constant:0];
  }
  
  NSLayoutConstraint *ratio = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorWheelView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
  NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
  NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
  
  scaleConstraint.active = true;
  ratio.active = true;
  centerX.active = true;
  centerY.active = true;
  }

-(BOOL)isLandscapeOrientation {
  CGSize size = [UIScreen mainScreen].bounds.size;
  return size.width > size.height;
}

-(void)setupUI {
//  UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//  UIVisualEffectView *backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//  backgroundBlurView.frame = self.view.frame;
//  [self.view addSubview:backgroundBlurView];
//  [self.view sendSubviewToBack:backgroundBlurView];
  self.view.backgroundColor = [UIColor darkGrayColor];
}

-(void)sendColorIndexToWatch:(NSInteger)index {
  NSNumber *updatedIndex = [NSNumber numberWithInteger:index];
  NSDictionary *message = @{kUpdatedColorIndexKey: updatedIndex};
  [self.session sendMessage:message replyHandler:nil errorHandler:nil];
}

-(void)handleSpin:(SpinGestureRecognizer *)spinGesture {
  
  if (spinGesture.state == UIGestureRecognizerStateEnded) {
    CGFloat currentAngle = [spinGesture currentRotationAngle];
    NSInteger newIndex = [self.colorWheelView.delegate colorWheel:self.colorWheelView adjustedIndexForAngle:currentAngle];
    [self setNewIndex:newIndex];
  }
}

-(void)setNewIndex:(NSInteger)index {
  [[Colors shared] updateCurrentIndex:index];
  [self sendColorIndexToWatch:index];
  [self.colorWheelView.delegate colorWheel:self.colorWheelView spinToColorAtIndex:index];
}

#pragma mark - Watch Session Delegate

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
  NSNumber *updatedIndex = message[kUpdatedColorIndexKey];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.colorWheelView.delegate colorWheel:self.colorWheelView spinToColorAtIndex:updatedIndex.integerValue];
  });
}

-(void)sessionReachabilityDidChange:(WCSession *)session {
  if (session.reachable) {
    [self sendColorIndexToWatch:[Colors shared].currentIndex];
  }
}

@end
