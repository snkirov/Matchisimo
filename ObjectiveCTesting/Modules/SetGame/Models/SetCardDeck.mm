// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardDeck.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardDeck

- (instancetype) init {
  if (self = [super init]) {
    for (int shapeIndex = 1; shapeIndex < shapesCount; shapeIndex++) {
      for (int numberOfObjectsIndex = 1; numberOfObjectsIndex < numberOfObjectsCount; numberOfObjectsIndex++) {
        for (int fillIndex = 1; fillIndex < fillsCount; fillIndex++) {
          for (int colorIndex = 1; colorIndex < colorsCount; colorIndex++) {
            auto card = [[SetCard alloc] init];
            card.shape = (CARD_Shape)shapeIndex;
            card.numberOfObjects = (CARD_NumberOfObjects)numberOfObjectsIndex;
            card.fill = (CARD_Fill)fillIndex;
            card.color = (CARD_Color)colorIndex;
            [self addCard:card];
          }
        }
      }
    }
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
