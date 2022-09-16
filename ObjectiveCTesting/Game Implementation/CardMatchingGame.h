// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

@class Card, Deck;
@protocol CardMatchingServiceProtocol;

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly)BOOL canDrawMore;
@property (nonatomic, readonly)NSInteger score;
@property (nonatomic, readonly)id <CardMatchingServiceProtocol> matchingService;

- (instancetype)initUsingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger)matchCount;
- (instancetype)initUsingDeck:(Deck *)deck;

- (void)chooseCard:(Card *)card;
- (void)removeCard:(Card *)card;

- (Card *)drawNextCard;
- (Card *)getCardPointerForCard:(Card *)card;

// Protected
- (BOOL)compareCard:(Card *)card withCard:(Card *)otherCard;

@end

NS_ASSUME_NONNULL_END
