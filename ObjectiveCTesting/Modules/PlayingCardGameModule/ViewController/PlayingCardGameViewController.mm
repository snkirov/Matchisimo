// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardGameViewController.h"
#import "DeckFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
  return [DeckFactory generateDeckWithPlayingCards];
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
