// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardGameViewController.h"
#import "SetCard.h"
#import "DeckFactory.h"

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
  return [DeckFactory generateDeckWithSetCards];
}

- (void)updateTitleOfButton:(UIButton *)cardButton forCard:(Card *)card {
  [cardButton setAttributedTitle:((SetCard *)card).attributedContents forState:UIControlStateNormal];
}

- (UIImage *)backgroundImageForCard: (Card *)card {
  NSString * cardName = card.isChosen ? @"cardselected" : @"cardfront";
  return [UIImage imageNamed: cardName];
}

@end

NS_ASSUME_NONNULL_END
