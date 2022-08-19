// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardDeck.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardDeck

- (instancetype) init {

  if (self = [super init]) {
    for (NSString *shape in [SetCard validShapes]) {
      for (UIColor *color in [SetCard validColors]) {
        for (UIColor *stroke in [SetCard validStrokes]) {
          SetCard *card = [[SetCard alloc] initWithShape:shape withColor:color withStroke:stroke];
          NSLog(@"%@", card.attributedContents);
          [self addCard: card];
        }
      }
    }
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
