// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardUtil

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

@end

NS_ASSUME_NONNULL_END
