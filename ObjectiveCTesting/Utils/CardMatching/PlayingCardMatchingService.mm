// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardMatchingService.h"
#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardMatchingService

- (int)matchCard:(Card *)card withOtherCards:(NSArray *)otherCards {
  if (![card isKindOfClass:[PlayingCard class]]) {
    return 0;
  }
  auto playingCard = (PlayingCard *)card;

  int score = 0;

  for (PlayingCard *otherCard in otherCards) {
    if(playingCard.rank == otherCard.rank) {
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
