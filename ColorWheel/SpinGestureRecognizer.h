//
//  SpinGestureRecognizer.h
//  ColorWheel
//
//  Created by Chris Budro on 11/10/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface SpinGestureRecognizer : UIPanGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)reset;

-(CGFloat)currentRotationAngle;

@end
