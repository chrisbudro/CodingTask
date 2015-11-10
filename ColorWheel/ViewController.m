//
//  ViewController.m
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ViewController.h"
#import "ColorWheelView.h"
#import "CBSpinnerWheel.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "Constants.h"

@interface ViewController () <CBSpinnerWheelDelegate, WCSessionDelegate>

@property (weak, nonatomic) IBOutlet CBSpinnerWheel *spinnerWheelView;
@property (strong, nonatomic) WCSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.spinnerWheelView.delegate = self;
  self.session = [WCSession defaultSession];
  self.session.delegate = self;
  [self.session activateSession];
  
  UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  UIVisualEffectView *backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
  backgroundBlurView.frame = self.view.frame;
  [self.view addSubview:backgroundBlurView];
  [self.view sendSubviewToBack:backgroundBlurView];
  
}

#pragma mark - Spinner Wheel Delegate

-(void)spinner:(CBSpinnerWheel *)spinner didSelectColorAtIndex:(NSInteger)index {
  NSNumber *updatedIndex = [NSNumber numberWithInteger:index];
  NSDictionary *message = @{kUpdatedColorIndexKey: updatedIndex};
  [self.session sendMessage:message replyHandler:nil errorHandler:nil];
}

#pragma mark - Watch Session Delegate

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
  NSNumber *updatedIndex = message[kUpdatedColorIndexKey];
  [self.spinnerWheelView selectColorAtIndex:updatedIndex.integerValue];
}

@end
