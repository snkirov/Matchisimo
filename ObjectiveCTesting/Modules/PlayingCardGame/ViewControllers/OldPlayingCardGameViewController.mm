// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "OldPlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@implementation OldPlayingCardGameViewController

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (NSString *)navigationTitle {
  return @"Match Two";
}

- (void)updateTitleOfButton:(UIButton *)cardButton forCard:(Card *)card {
  [cardButton setTitle: [self titleForCard: card] forState: UIControlStateNormal];
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents : @"";
}

@end

NS_ASSUME_NONNULL_END
