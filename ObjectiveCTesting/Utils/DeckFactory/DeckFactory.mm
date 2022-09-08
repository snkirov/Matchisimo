// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "DeckFactory.h"
#import "Deck.h"
#import "PlayingCard.h"
#import "PlayingCardUtil.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DeckFactory

+ (Deck *)generateDeckWithPlayingCards {
  auto playingCardDeck = [[Deck alloc] init];
  for (NSString *suit in [PlayingCardUtil validSuits]) {
    for (NSUInteger rank = 1; rank <= [PlayingCardUtil maxRank]; rank++) {
      PlayingCard *card = [[PlayingCard alloc] initWithSuit:suit withRank:rank];
      [playingCardDeck addCard: card];
    }
  }
  return playingCardDeck;
}

+ (Deck *)generateDeckWithSetCards {
  auto setCardDeck = [[Deck alloc] init];
  for (int shapeIndex = 1; shapeIndex < shapesCount; shapeIndex++) {
    for (int colorIndex = 1; colorIndex < colorsCount; colorIndex++) {
      for (int fillIndex = 1; fillIndex < fillsCount; fillIndex++) {
        for (int numberOfShapesIndex = 1; numberOfShapesIndex < numberOfShapesCount; numberOfShapesIndex++) {
          auto card = [[SetCard alloc] initWithShape:(CARD_Shape)shapeIndex
                                           withColor:(CARD_Color)colorIndex
                                            withFill:(CARD_Fill)fillIndex
                                  withNumberOfShapes:(CARD_NumberOfShapes)numberOfShapesIndex];
          [setCardDeck addCard:card];
        }
      }
    }
  }
  return setCardDeck;
}

@end

NS_ASSUME_NONNULL_END
