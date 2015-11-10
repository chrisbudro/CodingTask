//
//  ColorWheelView.h
//  ColorWheel
//
//  Created by Chris Budro on 11/7/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBSpinnerWheel.h"

@interface ColorWheelView : UIView

@property (strong, nonatomic) NSArray *colors;
@property (nonatomic) NSMutableArray *piePieces;

-(instancetype)initWithColors:(NSArray *)colors;

@end
