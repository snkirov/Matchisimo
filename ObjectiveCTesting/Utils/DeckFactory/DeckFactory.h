// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Deck;

/// Factory class for deck generation.
@interface DeckFactory : NSObject

/// Generates a deck which contains every `PlayingCard`.
+ (Deck *)generateDeckWithPlayingCards;
/// Generates a deck which contains every `SetCard`.
+ (Deck *)generateDeckWithSetCards;

@end

NS_ASSUME_NONNULL_END
