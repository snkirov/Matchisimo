// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

@protocol CardProtocol;

@class Deck;

/// Base class used to define the common behaviour for other `CardMatchingGame` objects.
/// Handles game and score logic.
@interface CardMatchingGame : NSObject

/// Shows whether more cards can be drawn.
@property (nonatomic, readonly) BOOL canDrawMore;
/// Shows the current score.
@property (nonatomic, readonly) NSInteger score;

/// Initializes the game with a given deck and the number of cards required for a match.
- (instancetype)initUsingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger)matchCount;
/// Initializes the game with a given deck and the default number of cards required for a match.
- (instancetype)initUsingDeck:(Deck *)deck;

/// Choses the given card and tries to match it, if enough cards have been selected.
- (void)chooseCard:(id <CardProtocol>)card;
/// Removes the given card from the game.
- (void)removeCard:(id <CardProtocol>)card;

/// Adds another card to the game.
- (nullable id <CardProtocol>)drawNextCard;

@end

NS_ASSUME_NONNULL_END
