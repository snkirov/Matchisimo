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
      [playingCardDeck addCardAtTheBottom: card];
    }
  }
  return playingCardDeck;
}

+ (Deck *)generateDeckWithSetCards {
  auto setCardDeck = [[Deck alloc] init];
  for (NSString *shape in [SetCard validShapes]) {
    for (UIColor *color in [SetCard validColors]) {
      for (UIColor *stroke in [SetCard validStrokes]) {
        SetCard *card = [[SetCard alloc] initWithShape:shape withColor:color withStroke:stroke];
        [setCardDeck addCardAtTheBottom: card];
      }
    }
  }
  return setCardDeck;
}

@end

NS_ASSUME_NONNULL_END
