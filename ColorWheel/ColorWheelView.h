//
//  ColorWheelView.h
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorWheelDelegate.h"

@interface ColorWheelView : UIView

@property (weak, nonatomic) id <ColorWheelDelegate> delegate;
-(instancetype)initWithColors:(NSArray *)colors;

@end
