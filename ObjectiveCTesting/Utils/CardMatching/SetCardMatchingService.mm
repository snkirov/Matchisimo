// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardMatchingService.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardMatchingService

- (int)matchCard:(Card *)card withOtherCards:(NSArray<Card *> *)otherCards {
  if (![card isKindOfClass:[SetCard class]]) {
    LogDebug(@"Wrong type of card passed into SetCardMatchingService matchCard().");
    return 0;
  }

  int score = 0;

  NSArray<Card *> *cards = [otherCards arrayByAddingObject:card];
  
  if ([self hasFoundMatchForCards:cards]) {
    score = 4;
  }

  return score;
}

- (BOOL)hasFoundMatchForCards:(NSArray<Card *> *)cards {
  // All components of the different cards should be matched in order for the cards to match.
  auto hasMatched = [self evaluateShapesForCards:cards] && [self evaluateColorsForCards:cards]
    && [self evaluateFillsForCards:cards] && [self evaluateNumberOfShapesForCards:cards];
  return hasMatched;
}

/// As per the rules of the game Set, we want to check whether the shapes of the given cards form a compoment match.
/// Returns true if the shapes form a match and false otherwise.
/// The algorithm is as follows.
/// 1. Create an array with all possible shapes.
/// 2. Iterate through each card and remove the coresponding shape from the array.
/// 3. A match is formed if either all shapes have been removed from the array or if only one shape has been removed.
- (BOOL)evaluateShapesForCards:(NSArray<Card *> *)cards {
  NSMutableArray *shapes = [[SetCardUtil shapesArray] mutableCopy];
  auto shapesOriginalCount = shapes.count;
  for (SetCard *card in cards) {
    if ([shapes containsObject:[NSNumber numberWithInteger:card.shape]]) {
      [shapes removeObject:[NSNumber numberWithInteger:card.shape]];
    }
  }
  auto allCardsHaveTheSameShape = shapesOriginalCount - 1 == shapes.count;
  auto allCardsHaveDifferentShapes = shapes.count == 0;
  return allCardsHaveTheSameShape || allCardsHaveDifferentShapes;
}

/// As per the rules of the game Set, we want to check whether the colors of the given cards form a compoment match.
/// Returns true if the colors form a match and false otherwise.
/// The algorithm is as follows.
/// 1. Create an array with all possible colors.
/// 2. Iterate through each card and remove the coresponding color from the array.
/// 3. A match is formed if either all colors have been removed from the array or if only one color has been removed.
- (BOOL)evaluateColorsForCards:(NSArray<Card *> *)cards {
  NSMutableArray *colors = [[SetCardUtil colorsArray] mutableCopy];
  auto colorsOriginalCount = colors.count;
  for (SetCard *card in cards) {
    if ([colors containsObject:[NSNumber numberWithInteger:card.color]]) {
      [colors removeObject:[NSNumber numberWithInteger:card.color]];
    }
  }
  auto allCardsHaveTheSameColor = colorsOriginalCount - 1 == colors.count;
  auto allCardsHaveDifferentColors = colors.count == 0;
  return allCardsHaveTheSameColor || allCardsHaveDifferentColors;
}

/// As per the rules of the game Set, we want to check whether the fills of the given cards form a compoment match.
/// Returns true if the fills form a match and false otherwise.
/// The algorithm is as follows.
/// 1. Create an array with all possible fills.
/// 2. Iterate through each card and remove the coresponding fill from the array.
/// 3. A match is formed if either all fills have been removed from the array or if only one fill has been removed.
- (BOOL)evaluateFillsForCards:(NSArray<Card *> *)cards {
  NSMutableArray *fills = [[SetCardUtil fillsArray] mutableCopy];
  auto fillsOriginalCount = fills.count;
  for (SetCard *card in cards) {
    if ([fills containsObject:[NSNumber numberWithInteger:card.fill]]) {
      [fills removeObject:[NSNumber numberWithInteger:card.fill]];
    }
  }
  auto allCardsHaveTheSameFill = fillsOriginalCount - 1 == fills.count;
  auto allCardsHaveDifferentFills = fills.count == 0;
  return allCardsHaveTheSameFill || allCardsHaveDifferentFills;
}

/// As per the rules of the game Set, we want to check whether the number of shapes of the given cards form a compoment match.
/// Returns true if the numbers of shapes form a match and false otherwise.
/// The algorithm is as follows.
/// 1. Create an array with all possible numbers of shapes.
/// 2. Iterate through each card and remove the coresponding number from the array.
/// 3. A match is formed if either all numbers have been removed from the array or if only one number has been removed.
- (BOOL)evaluateNumberOfShapesForCards:(NSArray<Card *> *)cards {
  NSMutableArray *numberOfShapes = [[SetCardUtil numberOfShapesArray] mutableCopy];
  auto numberOfShapesOriginalCount = numberOfShapes.count;
  for (SetCard *card in cards) {
    if ([numberOfShapes containsObject:[NSNumber numberWithInteger:card.numberOfShapes]]) {
      [numberOfShapes removeObject:[NSNumber numberWithInteger:card.numberOfShapes]];
    }
  }
  auto allCardsHaveTheSameNumberOfShapes =
    numberOfShapesOriginalCount - 1 == numberOfShapes.count;
  auto allCardsHaveDifferentNumbersOfShapes = numberOfShapes.count == 0;
  return allCardsHaveTheSameNumberOfShapes || allCardsHaveDifferentNumbersOfShapes;
}

@end

NS_ASSUME_NONNULL_END
