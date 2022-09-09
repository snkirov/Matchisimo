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
  self.cardMatchingGame = [[PlayingCardMatchingGame alloc] initUsingDeck:playingDeck withMatchCount:3];
}

- (CardView *)setupCardViewAtIndex:(NSUInteger)index {
  auto cardView = [[PlayingCardView alloc] init];
  cardView.backgroundColor = UIColor.clearColor;
  auto playingCard = (PlayingCard *)[self.cardMatchingGame cardAtIndex:index];
  [cardView setupWithPlayingCard:playingCard];
  cardView.faceUp = true;
  return cardView;
}

- (CardView *)setupCardViewAtRow:(NSUInteger)row atColumn:(NSUInteger)column {
  auto frame = [self.cardGrid frameOfCellAtRow:row inColumn:column];

  auto cardView = [[PlayingCardView alloc] initWithFrame:frame];
  cardView.backgroundColor = UIColor.clearColor;

  auto index = [self.cardGrid getIndexForRow:row andColumn:column];
  auto playingCard = (PlayingCard *)[self.cardMatchingGame cardAtIndex:index];
  cardView.faceUp = true;

  [cardView setupWithPlayingCard:playingCard];
  return cardView;
}

@end

NS_ASSUME_NONNULL_END
