// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardGameViewController.h"
#import "Grid.h"
#import "DeckFactory.h"
#import "PlayingCardMatchingGame.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardGameViewController

- (void)setupCardMatchingGame {
  auto playingDeck = [DeckFactory generateDeckWithPlayingCards];
  self.cardMatchingGame = [[PlayingCardMatchingGame alloc] initUsingDeck:playingDeck withMatchCount:2];
}

- (Card *)getCardForView:(CardView *)cardView {
  if (![cardView isKindOfClass:[PlayingCardView class]]) {
    return nil;
  }
  auto playingCardView = (PlayingCardView *)cardView;
  auto card = [[PlayingCard alloc] initWithSuit:playingCardView.suit
                                       withRank:playingCardView.rank];
  return card;
}

- (CardView *)generateCardView {
  auto cardView = [[PlayingCardView alloc] init];
  auto playingCard = (PlayingCard *)[self.cardMatchingGame drawNextCard];
  [cardView setupWithPlayingCard:playingCard];
  return cardView;
}

@end

NS_ASSUME_NONNULL_END
