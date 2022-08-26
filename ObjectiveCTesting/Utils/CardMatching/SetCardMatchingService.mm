// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardMatchingService.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardMatchingService

- (int)matchCard:(Card *)card withOtherCards:(NSMutableArray *)cards { 
  if (![card isKindOfClass:[SetCard class]]) {
    return 0;
  }

  int score = 0;

  NSMutableArray<NSString *> *shapes = [[SetCard validShapes] mutableCopy];
  NSMutableArray<UIColor *>  *colors = [[SetCard validColors] mutableCopy];
  NSMutableArray<UIColor *>  *strokes = [[SetCard validStrokes] mutableCopy];

  [cards addObject:self];

  for (SetCard *card in cards) {
    if ([shapes containsObject:card.shape]) {
      [shapes removeObject:card.shape];
    }
    if ([colors containsObject:card.color]) {
      [colors removeObject:card.color];
    }
    if ([strokes containsObject:card.stroke]) {
      [strokes removeObject:card.stroke];
    }
  }

  if ((shapes.count == 2 || shapes.count == 0) &&
      (colors.count == 2 || colors.count == 0) &&
      (strokes.count == 2 || strokes.count == 0)) {
    score = 4;
  }

  return score;
}

@end

NS_ASSUME_NONNULL_END
