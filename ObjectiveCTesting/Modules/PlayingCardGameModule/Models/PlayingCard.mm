// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCard

- (int)match:(NSArray *)otherCards {
  int score = 0;

  for (PlayingCard *card in otherCards) {
    if(self.rank == card.rank) {
      score += 4;
    }
    if (self.suit == card.suit) {
      score += 1;
    }
  }

  return score;
}

@synthesize suit = _suit;

- (NSString *)suit {
  return _suit ? _suit : @"?";
}

- (void)setSuit: (NSString *)suit {
  if ([[PlayingCard validSuits] containsObject: suit]) {
    _suit = suit;
  }
}

- (void)setRank: (NSUInteger)rank {
  if (rank <= [PlayingCard maxRank]) {
    _rank = rank;
  }
}

+ (NSArray *)validSuits {
  return @[@"♥️",@"♦️",@"♠️",@"♣️"];
}

+ (NSArray *)rankStrings {
  return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
              @"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank {
  return [[self rankStrings] count] - 1;
}

- (NSString *)contents {
  return [[PlayingCard rankStrings][self.rank]
              stringByAppendingString: self.suit];
}

@end

NS_ASSUME_NONNULL_END
