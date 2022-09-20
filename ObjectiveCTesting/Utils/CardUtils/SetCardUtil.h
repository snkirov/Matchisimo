// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

/// Contains all valid shapes for a `SetCard`.
typedef enum {
    Oval = 1,
    Squiggle,
    Diamond,
    shapesCount, // helper value for iterating through the enum
} CARD_Shape;

/// Contains all valid colors for a `SetCard`.
typedef enum {
  Green = 1,
  Red,
  Purple,
  colorsCount, // helper value for iterating through the enum
} CARD_Color;

/// Contains all valid fills for a `SetCard`.
typedef enum {
  Unfilled = 1,
  Striped,
  Solid,
  fillsCount, // helper value for iterating through the enum
} CARD_Fill;

/// Contains all valid number of shapes for a `SetCard`.
typedef enum {
  One = 1,
  Two,
  Three,
  numberOfShapesCount, // helper value for iterating through the enum
} CARD_NumberOfShapes;

/// Utility class with helper methods for `SetCard`
@interface SetCardUtil : NSObject
/// Returns an array with all valid shapes.
@property(class, nonatomic, readonly)NSArray *shapesArray;
/// Returns an array with all valid colors.
@property(class, nonatomic, readonly)NSArray *colorsArray;
/// Returns an array with all valid fills.
@property(class, nonatomic, readonly)NSArray *fillsArray;
/// Returns an array with all valid numbers of shapes.
@property(class, nonatomic, readonly)NSArray *numberOfShapesArray;

@end

NS_ASSUME_NONNULL_END
