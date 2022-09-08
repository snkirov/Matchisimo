// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCard.h"
#import "PlayingCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCard ()
@property (nonatomic, readwrite) NSString *suit;
@property (nonatomic, readwrite) NSUInteger rank;
@end

@implementation PlayingCard

- (instancetype) initWithSuit:(NSString *)suit withRank:(NSUInteger)rank {
  if (self = [super init]) {
    auto isValidSuit = [[PlayingCardUtil validSuits] containsObject: suit];
    auto isValidRank = rank <= [PlayingCardUtil maxRank];
    if (!isValidSuit || !isValidRank) {
      self = nil;
      return nil;
    }
    _suit = suit;
    _rank = rank;
  }
  return self;
}

- (NSString *)contents {
  return [[PlayingCardUtil rankStrings][self.rank]
          stringByAppendingString: self.suit];
}

@end

NS_ASSUME_NONNULL_END
