// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "BaseGameViewController+Protected.h"
#import "DeckFactory.h"
#import "Grid.h"
#import "PlayingCard.h"
#import "PlayingCardGameViewController.h"
#import "PlayingCardMatchingGame.h"
#import "PlayingCardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardGameViewController

- (void)setupCardMatchingGame {
  auto playingDeck = [DeckFactory generateDeckWithPlayingCards];
  self.cardMatchingGame = [[PlayingCardMatchingGame alloc] initUsingDeck:playingDeck withMatchCount:2];
}

- (Card *)getCardForView:(CardView *)cardView {
  if (![cardView isKindOfClass:[PlayingCardView class]]) {
    LogDebug(@"CardView in getCardForView is not of kind PlayingCardView.");
    return nil;
  }
  if (![self.cardMatchingGame isKindOfClass:[PlayingCardMatchingGame class]]) {
    LogDebug(@"CardMatchingGame in getCardForView is not of kind PlayingCardMatchingGame.");
    return nil;
  }

  auto playingCardView = (PlayingCardView *)cardView;
  auto playingCardMatchingGame = (PlayingCardMatchingGame *)self.cardMatchingGame;
  auto card = [playingCardMatchingGame getCardForSuit:playingCardView.suit
                                              andRank:playingCardView.rank];
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
