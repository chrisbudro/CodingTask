//
//  AppDelegate.m
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "AppDelegate.h"
#import "Colors.h"

@implementation AppDelegate

- (void)applicationWillResignActive:(UIApplication *)application {
  [[Colors shared] saveCurrentColorIndex];
}

-(void)applicationWillTerminate:(UIApplication *)application {
  [[Colors shared] saveCurrentColorIndex];
}

@end
