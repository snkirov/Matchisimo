// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (NSString *)navigationTitle {
  return @"Match Two";
}

@end

NS_ASSUME_NONNULL_END
