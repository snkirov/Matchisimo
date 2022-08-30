// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

@class Card, Deck;

@interface DeckUtil : NSObject
+ (Card *)drawRandomCardFromDeck:(Deck *)deck;
@end

NS_ASSUME_NONNULL_END
