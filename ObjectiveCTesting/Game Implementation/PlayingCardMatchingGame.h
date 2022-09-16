// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardMatchingGame.h"

NS_ASSUME_NONNULL_BEGIN

@class PlayingCard;

@interface PlayingCardMatchingGame : CardMatchingGame

- (PlayingCard *)getCardForSuit:(NSString *)suit andRank:(NSUInteger)rank;

@end

NS_ASSUME_NONNULL_END
