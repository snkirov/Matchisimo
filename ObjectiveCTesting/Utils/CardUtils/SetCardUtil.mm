// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardUtil

static NSArray *_shapesArray = nil;
static NSArray *_colorsArray = nil;
static NSArray *_fillsArray = nil;
static NSArray *_numberOfShapesArray = nil;

+ (NSArray *)shapesArray {
  if (_shapesArray == nil) {
    auto shapes = [[NSMutableArray alloc] init];
    for (int i = 1; i < shapesCount; i++) {
      [shapes addObject:[NSNumber numberWithInteger:i]];
    }
    _shapesArray = [shapes copy];
  }
  return _shapesArray;
}

+ (NSArray *)colorsArray {
  if (_colorsArray == nil) {
    auto colors = [[NSMutableArray alloc] init];
    for (int i = 1; i < colorsCount; i++) {
      [colors addObject:[NSNumber numberWithInteger:i]];
    }
    _colorsArray = [colors copy];
  }
  return _colorsArray;
}

+ (NSArray *)fillsArray {
  if (_fillsArray == nil) {
    auto fills = [[NSMutableArray alloc] init];
    for (int i = 1; i < fillsCount; i++) {
      [fills addObject:[NSNumber numberWithInteger:i]];
    }
    _fillsArray = [fills copy];
  }
  return _fillsArray;
}

+ (NSArray *)numberOfShapesArray {
  if (_numberOfShapesArray == nil) {
    auto numberOfShapes = [[NSMutableArray alloc] init];
    for (int i = 1; i < numberOfShapesCount; i++) {
      [numberOfShapes addObject:[NSNumber numberWithInteger:i]];
    }
    _numberOfShapesArray = [numberOfShapes copy];
  }
  return _numberOfShapesArray;
}

@end

NS_ASSUME_NONNULL_END
