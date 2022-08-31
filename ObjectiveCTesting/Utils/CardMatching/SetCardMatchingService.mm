// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardMatchingService.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardMatchingService

- (int)matchCard:(Card *)card withOtherCards:(NSArray *)cards {
  if (![card isKindOfClass:[SetCard class]]) {
    return 0;
  }

  int score = 0;

  NSMutableArray *mutableCards = [cards mutableCopy];
  NSMutableArray *shapes = [[SetCardUtil shapesArray] mutableCopy];
  NSMutableArray *colors = [[SetCardUtil colorsArray] mutableCopy];
  NSMutableArray *fills = [[SetCardUtil fillsArray] mutableCopy];
  NSMutableArray *numberOfObjects = [[SetCardUtil numberOfObjectsArray] mutableCopy];
  [mutableCards addObject:card];

  auto shapesOriginalCount = shapes.count;
  auto colorsOriginalCount = colors.count;
  auto fillsOriginalCount = fills.count;
  auto numberOfObjectsOriginalCount = numberOfObjects.count;

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
    if ([numberOfObjects containsObject:[NSNumber numberWithInteger:card.numberOfObjects]]) {
      [numberOfObjects removeObject:[NSNumber numberWithInteger:card.numberOfObjects]];
    }
  }
  
  if ((shapes.count == shapesOriginalCount - 1 || shapes.count == 0) &&
      (colors.count == colorsOriginalCount - 1 || colors.count == 0) &&
      (fills.count == fillsOriginalCount - 1 || fills.count == 0) &&
      (numberOfObjects.count == numberOfObjectsOriginalCount - 1 || numberOfObjects.count == 0)){
    score = 4;
  }

  return score;
}

@end

NS_ASSUME_NONNULL_END
