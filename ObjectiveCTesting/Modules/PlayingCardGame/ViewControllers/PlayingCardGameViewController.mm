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

- (CardView *)setupCardViewAtIndex:(NSUInteger)index {
  auto cardView = [[PlayingCardView alloc] init];
  cardView.backgroundColor = UIColor.clearColor;
  auto playingCard = (PlayingCard *)[self.cardMatchingGame cardAtIndex:index];
  [cardView setupWithPlayingCard:playingCard];
  cardView.selected = false;
  return cardView;
}

- (CardView *)setupCardViewAtRow:(NSUInteger)row atColumn:(NSUInteger)column {
  auto frame = [self.cardGrid frameOfCellAtRow:row inColumn:column];

  auto cardView = [[PlayingCardView alloc] init];
  cardView.frame = CGRectMake(self.view.center.x, self.view.center.y / 2, 0, 0);

  [UIView animateWithDuration:1.0 animations:^{
    cardView.frame = frame;
  }];

  cardView.backgroundColor = UIColor.clearColor;

  auto index = [self.cardGrid getIndexForRow:row andColumn:column];
  auto playingCard = (PlayingCard *)[self.cardMatchingGame cardAtIndex:index];
  cardView.selected = false;

  [cardView setupWithPlayingCard:playingCard];
  return cardView;
}

@end

NS_ASSUME_NONNULL_END
