// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

@class Card;

/// Protocol that defines the expected behaviour of a CardMatchingService.
@protocol CardMatchingServiceProtocol <NSObject>

/// Method which matches a card to a given array of cards.
/// - Parameters:
///   - card: Card to be matched
///   - cards: Cards with which it is matched
/// - Returns:
/// If the match is successful, the points awarded for it.
/// Otherwise, `0`.
- (int)matchCard:(Card *)card withOtherCards:(NSArray<Card *> *)cards;

@end

NS_ASSUME_NONNULL_END
