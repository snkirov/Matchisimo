// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "DeckFactory.h"
#import "Deck.h"
#import "PlayingCard.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DeckFactory

+ (Deck *)generateDeckWithPlayingCards {
  auto playingCardDeck = [[Deck alloc] init];
  for (NSString *suit in [PlayingCard validSuits]) {
    for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
      PlayingCard *card = [[PlayingCard alloc] init];
      card.rank = rank;
      card.suit = suit;
      [playingCardDeck addCard: card];
    }
  }
  return playingCardDeck;
}

+ (Deck *)generateDeckWithSetCards {
  auto setCardDeck = [[Deck alloc] init];
  for (int shapeIndex = 1; shapeIndex < shapesCount; shapeIndex++) {
    for (int numberOfShapesIndex = 1; numberOfShapesIndex < numberOfShapesCount; numberOfShapesIndex++) {
      for (int fillIndex = 1; fillIndex < fillsCount; fillIndex++) {
        for (int colorIndex = 1; colorIndex < colorsCount; colorIndex++) {
          auto card = [[SetCard alloc] init];
          card.shape = (CARD_Shape)shapeIndex;
          card.numberOfShapes = (CARD_NumberOfShapes)numberOfShapesIndex;
          card.fill = (CARD_Fill)fillIndex;
          card.color = (CARD_Color)colorIndex;
          [setCardDeck addCard:card];
        }
      }
    }
  }
  return setCardDeck;
}

@end

NS_ASSUME_NONNULL_END
