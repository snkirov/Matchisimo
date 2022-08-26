// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "Deck.h"
#import "Card.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckUtil : NSObject
+ (Card *)drawRandomCardFromDeck:(Deck *)deck;
@end

NS_ASSUME_NONNULL_END
