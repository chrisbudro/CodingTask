//
//  InterfaceController.m
//  Watch Extension
//
//  Created by Chris Budro on 11/8/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "Colors.h"
#import "Constants.h"

CGFloat const kColorFadeDuration = 0.5;

@interface InterfaceController() <WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *colorImage;
@property (strong, nonatomic) WCSession *session;
@property (strong, nonatomic) UIImage *circleImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *colorCircleButton;
@property (nonatomic) NSInteger currentIndex;

@end


@implementation InterfaceController

#pragma mark - Life Cycle Methods

-(instancetype)init {
  self = [super init];
  if (self) {
    [self setupWatchConnectivitySession];
  }
  return self;
}

-(void)awakeWithContext:(id)context {
  [self drawCircleTemplate];
  [self transitionToColorAtIndex:self.currentIndex];
}

#pragma mark - Actions

- (IBAction)circleWasPressed {
  NSInteger nextIndex = [[Colors shared] nextIndex];
  self.currentIndex = nextIndex;

  NSDictionary *message = @{kUpdatedColorIndexKey: [NSNumber numberWithInteger:self.currentIndex]};
  [self.session sendMessage:message replyHandler:nil errorHandler:nil];
}

#pragma mark - Helper Methods

-(void)drawCircleTemplate {
  CGSize size = self.contentFrame.size;
  CGFloat sideLength = MIN(size.width, size.height);
  
  UIGraphicsBeginImageContext(size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextAddEllipseInRect(context, CGRectMake(0, 0, sideLength, sideLength));
  CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
  CGContextFillPath(context);
  
  UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
  self.circleImage = [circleImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.colorImage setImage:self.circleImage];

  UIGraphicsEndImageContext();
}

-(void)setupWatchConnectivitySession {
  if ([WCSession isSupported]) {
    self.session = [WCSession defaultSession];
    self.session.delegate = self;
    [self.session activateSession];
  }
}

-(void)transitionToColorAtIndex:(NSInteger)index {
  UIColor *color = [[Colors shared] colorAtIndex:index];
  [self animateWithDuration:kColorFadeDuration animations:^{
    [self.colorImage setTintColor:color];
  }];
}

#pragma mark - Watch Connectivity Session Delegate

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
  NSNumber *updatedColorIndex = message[kUpdatedColorIndexKey];
  self.currentIndex = updatedColorIndex.integerValue;
}

#pragma mark - Getters/Setters

-(void)setCurrentIndex:(NSInteger)currentIndex {
  [[Colors shared] updateCurrentIndex:currentIndex];
  [self transitionToColorAtIndex:currentIndex];
}

-(NSInteger)currentIndex {
  return [Colors shared].currentIndex;
}

@end



