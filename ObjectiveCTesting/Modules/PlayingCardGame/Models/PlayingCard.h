// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCard : Card

- (instancetype) initWithSuit:(NSString *)suit withRank:(NSUInteger)rank;

@property (nonatomic, readonly) NSString *suit;
@property (nonatomic, readonly) NSUInteger rank;

@end

NS_ASSUME_NONNULL_END
