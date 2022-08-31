// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardUtil 

+ (NSArray *)shapesArray {
  auto shapes = [[NSMutableArray alloc] init];
  for (int i = 1; i < shapesCount; i++) {
    [shapes addObject:[NSNumber numberWithInteger:i]];
  }
  return shapes;
}

+ (NSArray *)colorsArray {
  auto colors = [[NSMutableArray alloc] init];
  for (int i = 1; i < colorsCount; i++) {
    [colors addObject:[NSNumber numberWithInteger:i]];
  }
  return colors;
}

+ (NSArray *)fillsArray {
  auto fills = [[NSMutableArray alloc] init];
  for (int i = 1; i < fillsCount; i++) {
    [fills addObject:[NSNumber numberWithInteger:i]];
  }
  return fills;
}

+ (NSArray *)numberOfObjectsArray {
  auto numberOfObjects = [[NSMutableArray alloc] init];
  for (int i = 1; i < numberOfObjectsCount; i++) {
    [numberOfObjects addObject:[NSNumber numberWithInteger:i]];
  }
  return numberOfObjects;
}

@end

NS_ASSUME_NONNULL_END
