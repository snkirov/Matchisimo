// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardMatchingGame.h"
#import "PlayingCardMatchingService.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardMatchingGame()
@property (nonatomic, readwrite) id <CardMatchingServiceProtocol> matchingService;
@end

@implementation PlayingCardMatchingGame

@synthesize matchingService = _matchingService;

- (instancetype)initUsingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger) matchCount {
  if (self = [super initUsingDeck:deck withMatchCount:matchCount]) {
    self.matchingService = [[PlayingCardMatchingService alloc] init];
  }
  return self;
}

- (BOOL)compareCard:(Card *)card withCard:(Card *)otherCard {
  if (![card isKindOfClass:[PlayingCard class]] && ![otherCard isKindOfClass:[PlayingCard class]]) {
    return FALSE;
  }
  auto playingCard = (PlayingCard *)card;
  auto otherPlayingCard = (PlayingCard *)otherCard;
  return playingCard.rank == otherPlayingCard.rank && playingCard.suit == otherPlayingCard.suit;
}

@end

NS_ASSUME_NONNULL_END
