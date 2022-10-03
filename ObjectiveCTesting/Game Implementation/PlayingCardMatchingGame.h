// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardMatchingGame.h"

NS_ASSUME_NONNULL_BEGIN

@class PlayingCard;

/// Handles `PlayingCard` specific game logic.
@interface PlayingCardMatchingGame : CardMatchingGame

/// Retrieves the `PlayingCard` model from the `cards` array for the given suit and rank.
- (nullable PlayingCard *)getCardForSuit:(NSString *)suit andRank:(NSUInteger)rank;

@end

NS_ASSUME_NONNULL_END
