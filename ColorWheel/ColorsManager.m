//
//  Colors.m
//  ColorWheel
//
//  Created by Chris Budro on 11/9/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "ColorsManager.h"
#import "UIColor+HexColor.h"

NSString *const kSavedColorIndexKey = @"SavedColorIndex";

@interface ColorsManager ()

@property (strong, nonatomic) NSArray *list;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation ColorsManager

#pragma mark - Initializer

-(instancetype)init {
  self = [super init];
  if (self) {
    NSArray *colorArray = [self retrieveColorArrayFromPropertyList];
    self.list = colorArray;
    
    self.currentIndex = [self retrieveSavedColorIndex];
  }
  return self;
}

#pragma mark - Helper Methods

-(UIColor *)colorAtIndex:(NSInteger)index {
  if (index < self.list.count) {
    return self.list[index];
  }
  return nil;
}

-(NSArray *)colorList {
  return self.list;
}

-(void)updateCurrentIndex:(NSInteger)index {
  self.currentIndex = index;
  [self archiveCurrentColorIndex];
}

-(NSInteger)nextIndex {
  NSInteger updatedIndex = self.currentIndex + 1;
  if (updatedIndex >= self.list.count) {
    updatedIndex = 0;
  }
  return updatedIndex;
}

#pragma mark - Persistence

-(NSArray *)retrieveColorArrayFromPropertyList {
  NSString *colorFilePath = [[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"plist"];
  NSArray *hexColorArray = [NSArray arrayWithContentsOfFile:colorFilePath];
  NSMutableArray *convertedColorArray = [[NSMutableArray alloc] initWithCapacity:hexColorArray.count];
  
  for (NSString *hexColor in hexColorArray) {
    UIColor *color = [UIColor colorWithHexColor:hexColor];
    if (color) {
      [convertedColorArray addObject:color];
    }
  }
  return convertedColorArray;
}

-(void)archiveCurrentColorIndex {
  NSNumber *indexObject = [NSNumber numberWithInteger:self.currentIndex];
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:indexObject forKey:kSavedColorIndexKey];
}

-(void)save {
  [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)retrieveSavedColorIndex {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  if ([userDefaults objectForKey:kSavedColorIndexKey]) {
    NSNumber *savedColorIndex = [userDefaults objectForKey:kSavedColorIndexKey];
    return savedColorIndex.integerValue;
  }
  return 0;
}

@end
