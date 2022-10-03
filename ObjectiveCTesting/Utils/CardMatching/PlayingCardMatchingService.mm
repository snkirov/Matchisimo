// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardMatchingService.h"
#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardMatchingService

- (int)matchCard:(id <CardProtocol>)card withOtherCards:(NSArray<id <CardProtocol>> *)otherCards {

  for (id <CardProtocol> maybePlayingCard in [otherCards arrayByAddingObject:card]) {
    if (![maybePlayingCard isKindOfClass:[PlayingCard class]]) {
      LogDebug(@"Wrong type of card passed into PlayingCardMatchingService matchCard().");
      return 0;
    }
  }
  auto playingCard = (PlayingCard *)card;

  int score = 0;

  for (PlayingCard *otherCard in otherCards) {
    if (playingCard.rank == otherCard.rank) {
      score += 4;
    }
    if (playingCard.suit == otherCard.suit) {
      score += 1;
    }
  }

  return score;
}

@end

NS_ASSUME_NONNULL_END
