// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

@class Card, Deck;
@protocol CardMatchingServiceProtocol;

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount: (NSUInteger)count usingDeck: (Deck *)deck
                   withMatchCount:(NSUInteger)matchCount;
- (instancetype)initWithCardCount: (NSUInteger)count usingDeck: (Deck *)deck;

- (void)chooseCardAtIndex: (NSUInteger)index;

- (Card *)cardAtIndex: (NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSMutableString * lastMoveDescription;
@property (nonatomic, readonly) id <CardMatchingServiceProtocol> matchingService;

@end

NS_ASSUME_NONNULL_END