// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

/// Defines a model of a normal playing card.
@interface PlayingCard : Card

/// The suit of the card.
@property (nonatomic, readonly) NSString *suit;
/// The rank of the card.
@property (nonatomic, readonly) NSUInteger rank;

- (instancetype)initWithSuit:(NSString *)suit withRank:(NSUInteger)rank;

@end

NS_ASSUME_NONNULL_END
