//
//  UIColor+HexColor.m
//  ColorWheel
//
//  Created by Chris Budro on 11/9/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+colorWithHexColor:(NSString *)hexColor {
    NSScanner *scanner = [NSScanner scannerWithString:hexColor];
    unsigned int color = 0;
    [scanner scanHexInt:&color];
    
    int mask = 0x000000FF;
    CGFloat red = (color >> 16) & mask;
    CGFloat green = (color >> 8) & mask;
    CGFloat blue = color & mask;
    
    UIColor *newColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return newColor;
}

@end
