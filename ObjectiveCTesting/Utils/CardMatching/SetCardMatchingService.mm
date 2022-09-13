// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardMatchingService.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardMatchingService

- (int)matchCard:(Card *)card withOtherCards:(NSArray *)cards {
  if (![card isKindOfClass:[SetCard class]]) {
    LogDebug(@"Wrong type of card passed into SetCardMatchingService matchCard().");
    return 0;
  }

  int score = 0;

  NSMutableArray *mutableCards = [cards mutableCopy];
  NSMutableArray *shapes = [[SetCardUtil shapesArray] mutableCopy];
  NSMutableArray *colors = [[SetCardUtil colorsArray] mutableCopy];
  NSMutableArray *fills = [[SetCardUtil fillsArray] mutableCopy];
  NSMutableArray *numberOfShapes = [[SetCardUtil numberOfShapesArray] mutableCopy];
  [mutableCards addObject:card];

  auto shapesOriginalCount = shapes.count;
  auto colorsOriginalCount = colors.count;
  auto fillsOriginalCount = fills.count;
  auto numberOfShapesOriginalCount = numberOfShapes.count;

  for (SetCard *card in mutableCards) {
    if ([shapes containsObject:[NSNumber numberWithInteger:card.shape]]) {
      [shapes removeObject:[NSNumber numberWithInteger:card.shape]];
    }
    if ([colors containsObject:[NSNumber numberWithInteger:card.color]]) {
      [colors removeObject:[NSNumber numberWithInteger:card.color]];
    }
    if ([fills containsObject:[NSNumber numberWithInteger:card.fill]]) {
      [fills removeObject:[NSNumber numberWithInteger:card.fill]];
    }
    if ([numberOfShapes containsObject:[NSNumber numberWithInteger:card.numberOfShapes]]) {
      [numberOfShapes removeObject:[NSNumber numberWithInteger:card.numberOfShapes]];
    }
  }
  
  if ((shapes.count == shapesOriginalCount - 1 || shapes.count == 0) &&
      (colors.count == colorsOriginalCount - 1 || colors.count == 0) &&
      (fills.count == fillsOriginalCount - 1 || fills.count == 0) &&
      (numberOfShapes.count == numberOfShapesOriginalCount - 1 || numberOfShapes.count == 0)){
    score = 4;
  }

  return score;
}

@end

NS_ASSUME_NONNULL_END
