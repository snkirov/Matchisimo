// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardGameViewController

// Overwrites

- (NSString *)navigationTitle {
  return @"Set Three";
}

- (NSUInteger)cardsRequiredForMatch {
  return 3;
}

- (Deck *)createDeck {
  return [[SetCardDeck alloc] init];
}

- (UIImage *)backgroundImageForCard: (Card *)card {
  NSString * cardName = card.isChosen ? @"cardselected" : @"cardfront";
  return [UIImage imageNamed: cardName];
}

@end

NS_ASSUME_NONNULL_END
