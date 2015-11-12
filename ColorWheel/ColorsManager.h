//
//  Colors.h
//  ColorWheel
//
//  Created by Chris Budro on 11/9/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorsManager : NSObject

@property (readonly, nonatomic) NSInteger currentIndex;

-(UIColor *)colorAtIndex:(NSInteger)index;
-(NSArray *)colorList;
-(void)updateCurrentIndex:(NSInteger)index;
-(NSInteger)nextIndex;
-(void)saveCurrentColorIndex;

@end
