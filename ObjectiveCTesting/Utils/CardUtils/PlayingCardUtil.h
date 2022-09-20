// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

/// Utility class with helper methods for `PlayingCard`
@interface PlayingCardUtil : NSObject

/// Returns an array with all valid suits.
@property(class, nonatomic, readonly)NSArray *validSuits;
/// Returns an array with all valid ranks as strings.
@property(class, nonatomic, readonly)NSArray *rankStrings;
/// Returns the maximum valid rank.
@property(class, nonatomic, readonly)NSUInteger maxRank;

@end

NS_ASSUME_NONNULL_END
