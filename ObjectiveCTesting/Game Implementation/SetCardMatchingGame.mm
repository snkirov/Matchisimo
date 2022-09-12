// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardMatchingGame.h"
#import "SetCardMatchingService.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardMatchingGame()
@property (nonatomic, readwrite) id <CardMatchingServiceProtocol> matchingService;
@end

@implementation SetCardMatchingGame

@synthesize matchingService = _matchingService;

- (instancetype)initUsingDeck:(Deck *)deck {
  return [self initUsingDeck:deck withMatchCount:3];
}

- (instancetype)initUsingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger) matchCount {
  if (self = [super initUsingDeck:deck withMatchCount:matchCount]) {
    self.matchingService = [[SetCardMatchingService alloc] init];
  }
  return self;
}

- (BOOL)compareCard:(Card *)card withCard:(Card *)otherCard {
  if (![card isKindOfClass:[SetCard class]] && ![otherCard isKindOfClass:[SetCard class]]) {
    return false;
  }
  auto setCard = (SetCard *)card;
  auto otherSetCard = (SetCard *)otherCard;
  return setCard.color == otherSetCard.color && setCard.fill == otherSetCard.fill
    && setCard.shape == otherSetCard.shape && setCard.numberOfShapes == otherSetCard.numberOfShapes;
}

@end

NS_ASSUME_NONNULL_END
