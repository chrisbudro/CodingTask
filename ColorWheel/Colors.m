//
//  Colors.m
//  ColorWheel
//
//  Created by Chris Budro on 11/9/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "Colors.h"
#import "UIColor+HexColor.h"

NSString *const kCurrentColorKey = @"CurrentColor";

@interface Colors ()

@property (strong, nonatomic) NSArray *list;
@property (nonatomic) NSInteger lastSavedIndex;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation Colors

+(instancetype)shared {
  static Colors *sharedColors;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedColors = [[self alloc] init];
  });
  return sharedColors;
}

-(instancetype)init {
  self = [super init];
  if (self) {
    NSArray *colorArray = [self retrieveColorArrayFromPropertyList];
    self.list = colorArray;
    
    [self restoreLastSavedIndex];
  }
  return self;
}

-(UIColor *)colorAtIndex:(NSInteger)index {
  if (self.list.count > index) {
    return self.list[index];
  }
  return nil;
}

-(NSArray *)colorList {
  return self.list;
}

-(void)updateCurrentIndex:(NSInteger)index {
  self.currentIndex = index;
}

-(UIColor *)nextColor {
  NSInteger nextIndex = self.currentIndex + 1;
  if (nextIndex >= self.list.count) {
    self.currentIndex = 0;
  } else {
    self.currentIndex = nextIndex;
  }
  return self.list[self.currentIndex];
}

-(NSArray *)retrieveColorArrayFromPropertyList {
  NSString *colorFilePath = [[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"plist"];
  NSArray *hexColorArray = [NSArray arrayWithContentsOfFile:colorFilePath];
  NSMutableArray *convertedColorArray = [[NSMutableArray alloc] initWithCapacity:hexColorArray.count];
  
  for (NSString *hexColor in hexColorArray) {
    UIColor *color = [UIColor colorWithHexColor:hexColor];
    [convertedColorArray addObject:color];
  }
  return convertedColorArray;
}

-(void)restoreLastSavedIndex {
  UIColor *savedColor = [self retrieveSavedColor];
  if (savedColor) {
    NSInteger savedColorIndex = [self.list indexOfObject:savedColor];
    if (savedColorIndex != NSNotFound) {
      self.lastSavedIndex = savedColorIndex;
    }
  }
}

-(void)saveCurrentColor {
  UIColor *currentColor = self.list[self.currentIndex];
  NSData *currentColorData = [NSKeyedArchiver archivedDataWithRootObject:currentColor];
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:currentColorData forKey:kCurrentColorKey];
  [userDefaults synchronize];
}

-(UIColor *)retrieveSavedColor {
  UIColor *savedColor = nil;
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  if ([userDefaults objectForKey:kCurrentColorKey]) {
    NSData *colorData = [userDefaults objectForKey:kCurrentColorKey];
    savedColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
  }
  return savedColor;
}


@end
