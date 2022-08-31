// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    Oval = 1,
    Squiggle,
    Diamond,
    shapesCount, // helper value for iterating through the enum
} CARD_Shape;

typedef enum {
  Green = 1,
  Red,
  Purple,
  colorsCount, // helper value for iterating through the enum
} CARD_Color;

typedef enum {
  Unfilled = 1,
  Striped,
  Solid,
  fillsCount, // helper value for iterating through the enum
} CARD_Fill;

typedef enum {
  One = 1,
  Two = 2,
  Three = 3,
  numberOfShapesCount, // helper value for iterating through the enum
} CARD_NumberOfShapes;

@interface SetCardUtil : NSObject

+ (NSArray *)shapesArray;
+ (NSArray *)colorsArray;
+ (NSArray *)fillsArray;
+ (NSArray *)numberOfShapesArray;

@end

NS_ASSUME_NONNULL_END
