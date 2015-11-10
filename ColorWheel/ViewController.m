//
//  ViewController.m
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ViewController.h"
#import "CBSpinnerWheel.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "Constants.h"
#import "Colors.h"

@interface ViewController () <CBSpinnerWheelDelegate, WCSessionDelegate>

@property (weak, nonatomic) IBOutlet CBSpinnerWheel *spinnerWheelView;
@property (strong, nonatomic) WCSession *session;

@end

@implementation ViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupWatchConnectivitySession];
  if (self.session.reachable) {
    [self sendColorIndexToWatch:[Colors shared].currentIndex];
  }
  [self setupUI];
}

#pragma mark - Helper Methods

-(void)setupWatchConnectivitySession {
  self.spinnerWheelView.delegate = self;
  self.session = [WCSession defaultSession];
  self.session.delegate = self;
  [self.session activateSession];
}

-(void)setupUI {
  UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  UIVisualEffectView *backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
  backgroundBlurView.frame = self.view.frame;
  [self.view addSubview:backgroundBlurView];
  [self.view sendSubviewToBack:backgroundBlurView];
}

-(void)sendColorIndexToWatch:(NSInteger)index {
  NSNumber *updatedIndex = [NSNumber numberWithInteger:index];
  NSDictionary *message = @{kUpdatedColorIndexKey: updatedIndex};
  [self.session sendMessage:message replyHandler:nil errorHandler:nil];
}

#pragma mark - Spinner Wheel Delegate

-(void)spinner:(CBSpinnerWheel *)spinner didSelectColorAtIndex:(NSInteger)index {
  [self sendColorIndexToWatch:index];
}

#pragma mark - Watch Session Delegate

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
  NSNumber *updatedIndex = message[kUpdatedColorIndexKey];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.spinnerWheelView selectColorAtIndex:updatedIndex.integerValue];
  });
}

-(void)sessionReachabilityDidChange:(WCSession *)session {
  if (session.reachable) {
    [self sendColorIndexToWatch:[Colors shared].currentIndex];
  }
}

@end
