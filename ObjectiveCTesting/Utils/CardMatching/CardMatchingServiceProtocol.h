// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

@protocol CardProtocol;

/// Protocol that defines the expected behaviour of a CardMatchingService.
@protocol CardMatchingServiceProtocol <NSObject>

/// Method which matches a card to a given array of cards.
/// - Parameters:
///   - card: Card to be matched
///   - cards: Cards with which it is matched
/// - Returns:
/// If the match is successful, the points awarded for it.
/// Otherwise, `0`.
- (int)matchCard:(id <CardProtocol>)card withOtherCards:(NSArray<id <CardProtocol>> *)cards;

@end

NS_ASSUME_NONNULL_END
