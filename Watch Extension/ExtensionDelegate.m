//
//  ExtensionDelegate.m
//  Watch Extension
//
//  Created by Chris Budro on 11/8/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ExtensionDelegate.h"
#import "Colors.h"

@implementation ExtensionDelegate

- (void)applicationWillResignActive {
  [[Colors shared] saveCurrentColorIndex];
}

@end
