// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardUtil

static NSArray *_validSuits = @[@"♥️",@"♦️",@"♠️",@"♣️"];
static NSArray *_rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
                                 @"7",@"8",@"9",@"10",@"J",@"Q",@"K"];


+ (NSArray *)validSuits {
  return _validSuits;
}

+ (NSArray *)rankStrings {
  return _rankStrings;
}

+ (NSUInteger)maxRank {
  return [_rankStrings count] - 1;
}

@end

NS_ASSUME_NONNULL_END
