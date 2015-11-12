//
//  ViewController.m
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "MainViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "ColorWheelView.h"
#import "Constants.h"
#import "Colors.h"
#import "SpinGestureRecognizer.h"
#import "ColorWheelDelegate.h"

CGFloat const kColorWheelToSuperViewMultiplier = 0.80;

@interface MainViewController () <WCSessionDelegate>


@property (strong, nonatomic) ColorWheelView *colorWheelView;
@property (strong, nonatomic) WCSession *session;
@property (strong, nonatomic) SpinGestureRecognizer *spinGesture;
@property (strong, nonatomic) id <ColorWheelDelegate> colorWheelDelegate;

@property (strong, nonatomic) NSLayoutConstraint *portraitScaleConstraint;
@property (strong, nonatomic) NSLayoutConstraint *landscapeScaleConstraint;

@end

@implementation MainViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupColorWheel];
  [self setupWatchConnectivitySession];
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
  self.colorWheelDelegate = [[ColorWheelDelegate alloc] initWithColors:[[Colors shared] colorList]];
  self.colorWheelView = [[ColorWheelView alloc] initWithDelegate:self.colorWheelDelegate];
  self.spinGesture = [[SpinGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpin:)];
  [self.colorWheelView addGestureRecognizer:self.spinGesture];
  
  [self.view addSubview:self.colorWheelView];
  [self setupColorWheelConstraints];
}

-(void)setupColorWheelConstraints {
  self.view.translatesAutoresizingMaskIntoConstraints = false;
  self.colorWheelView.translatesAutoresizingMaskIntoConstraints = false;
  
  self.landscapeScaleConstraint = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:kColorWheelToSuperViewMultiplier constant:0];
  self.portraitScaleConstraint = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:kColorWheelToSuperViewMultiplier constant:0];
  NSLayoutConstraint *ratio = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.colorWheelView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
  NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
  NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.colorWheelView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
  
  ratio.active = true;
  centerX.active = true;
  centerY.active = true;
  [self setOrientationConstraintWithSize:self.view.bounds.size];
  }

-(void)setOrientationConstraintWithSize:(CGSize)size {
  BOOL isLandscape = size.width > size.height;
  if (isLandscape) {
    self.portraitScaleConstraint.active = false;
    self.landscapeScaleConstraint.active = true;
  } else {
    self.landscapeScaleConstraint.active = false;
    self.portraitScaleConstraint.active = true;
  }
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

-(void)sendColorIndexToWatch:(NSInteger)index {
  NSNumber *updatedIndex = [NSNumber numberWithInteger:index];
  NSDictionary *message = @{kUpdatedColorIndexKey: updatedIndex};
  [self.session sendMessage:message replyHandler:nil errorHandler:nil];
}

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

#pragma mark - Content Container Protocol
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [self setOrientationConstraintWithSize:size];
  [self.view layoutIfNeeded];
}

@end
