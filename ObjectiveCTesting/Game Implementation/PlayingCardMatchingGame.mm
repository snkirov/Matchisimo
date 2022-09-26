// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardMatchingGame+Protected.h"
#import "PlayingCard.h"
#import "PlayingCardMatchingGame.h"
#import "PlayingCardMatchingService.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardMatchingGame()

@property (nonatomic, readwrite) id <CardMatchingServiceProtocol> matchingService;

@end

@implementation PlayingCardMatchingGame

@synthesize matchingService = _matchingService;

- (instancetype)initUsingDeck:(Deck *)deck {
  return [self initUsingDeck:deck withMatchCount:2];
}

- (instancetype)initUsingDeck:(Deck *)deck
               withMatchCount:(NSUInteger) matchCount {
  if (self = [super initUsingDeck:deck withMatchCount:matchCount]) {
    self.matchingService = [[PlayingCardMatchingService alloc] init];
  }
  return self;
}

- (nullable PlayingCard *)getCardForSuit:(NSString *)suit andRank:(NSUInteger)rank {
  for (Card *card in self.cardsInPlay) {
    if (![card isKindOfClass:[PlayingCard class]]) {
      LogDebug(@"Card in getCardForSuit is not of kind PlayingCard.");
      continue;
    }
    auto playingCard = (PlayingCard *)card;
    if (playingCard.suit == suit && playingCard.rank == rank) {
      return playingCard;
    }
  }
  LogDebug(@"No PlayingCard with provided suit and rank present in cards array.");
  return nil;
}

@end

NS_ASSUME_NONNULL_END
