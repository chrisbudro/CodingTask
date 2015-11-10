//
//  Colors.m
//  ColorWheel
//
//  Created by Chris Budro on 11/9/15.
//  Copyright © 2015 Chris Budro. All rights reserved.
//

#import "Colors.h"
#import "UIColor+HexColor.h"

NSString *const kSavedColorIndexKey = @"SavedColorIndex";

@interface Colors ()

@property (strong, nonatomic) NSArray *list;
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
    
    self.currentIndex = [self retrieveSavedColorIndex];
  }
  return self;
}

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
}

-(NSInteger)nextIndex {
  NSInteger updatedIndex = self.currentIndex + 1;
  if (updatedIndex >= self.list.count) {
    updatedIndex = 0;
  }
  return updatedIndex;
}

-(NSArray *)retrieveColorArrayFromPropertyList {
  NSString *colorFilePath = [[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"plist"];
  NSArray *hexColorArray = [NSArray arrayWithContentsOfFile:colorFilePath];
  NSMutableArray *convertedColorArray = [[NSMutableArray alloc] initWithCapacity:hexColorArray.count];
  
  for (NSString *hexColor in hexColorArray) {
    UIColor *color = [UIColor colorWithHexColor:hexColor];
    [convertedColorArray addObject:color];
  }
  
  if (convertedColorArray.count <= 0) {
    NSArray *placeholderColorArray = @[[UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor yellowColor]];
    return [NSMutableArray arrayWithArray:placeholderColorArray];
  }
  return convertedColorArray;
}

-(void)saveCurrentColorIndex {
  NSNumber *indexObject = [NSNumber numberWithInteger:self.currentIndex];
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:indexObject forKey:kSavedColorIndexKey];
  [userDefaults synchronize];
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
