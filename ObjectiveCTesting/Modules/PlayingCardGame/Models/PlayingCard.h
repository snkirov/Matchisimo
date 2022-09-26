// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// Defines a model of a normal playing card.
@interface PlayingCard : NSObject <CardProtocol>

/// The suit of the card.
@property (nonatomic, readonly) NSString *suit;
/// The rank of the card.
@property (nonatomic, readonly) NSUInteger rank;

- (instancetype)initWithSuit:(NSString *)suit withRank:(NSUInteger)rank;

@end

NS_ASSUME_NONNULL_END
