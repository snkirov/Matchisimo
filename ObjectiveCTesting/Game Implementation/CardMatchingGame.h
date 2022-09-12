// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

@class Card, Deck;
@protocol CardMatchingServiceProtocol;

@interface CardMatchingGame : NSObject

- (instancetype)initUsingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger)matchCount;
- (instancetype)initUsingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;

- (Card *)getCardPointerForCard:(Card *)card;
- (void)removeCard:(Card *)card;

- (Card *)cardAtIndex: (NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSMutableString * lastMoveDescription;
@property (nonatomic, readonly) id <CardMatchingServiceProtocol> matchingService;

@end

NS_ASSUME_NONNULL_END
