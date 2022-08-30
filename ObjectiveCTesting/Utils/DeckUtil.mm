// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "DeckUtil.h"
#import "Deck.h"
NS_ASSUME_NONNULL_BEGIN

@implementation DeckUtil
+ (Card *)drawRandomCardFromDeck:(Deck *)deck {
  Card *randomCard = nil;

  if ([deck.cards count]) {
    unsigned index = arc4random() % [deck.cards count];
    randomCard = deck.cards[index];
    [deck.cards removeObjectAtIndex: index];
  }
  return randomCard;
}
@end

NS_ASSUME_NONNULL_END
