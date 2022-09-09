// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardGameViewController.h"
#import "Grid.h"
#import "DeckFactory.h"
#import "SetCardMatchingGame.h"
#import "SetCard.h"
#import "SetCardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardGameViewController

- (void)setupCardMatchingGame {
  auto setDeck = [DeckFactory generateDeckWithSetCards];
  self.cardMatchingGame = [[SetCardMatchingGame alloc] initUsingDeck:setDeck withMatchCount:3];
}

- (CardView *)setupCardViewAtIndex:(NSUInteger)index {
  auto cardView = [[SetCardView alloc] init];
  cardView.backgroundColor = UIColor.clearColor;
  auto setCard = (SetCard *)[self.cardMatchingGame cardAtIndex:index];
  [cardView setupWithSetCard:setCard];
  return cardView;
}

- (CardView *)setupCardViewAtRow:(NSUInteger)row atColumn:(NSUInteger)column {
  auto frame = [self.cardGrid frameOfCellAtRow:row inColumn:column];

  auto cardView = [[SetCardView alloc] init];
  cardView.frame = CGRectMake(self.view.center.x, self.view.center.y / 2, 0, 0);

  [UIView animateWithDuration:1.0 animations:^{
    cardView.frame = frame;
  }];
  cardView.backgroundColor = UIColor.clearColor;

  auto index = [self.cardGrid getIndexForRow:row andColumn:column];
  auto setCard = (SetCard *)[self.cardMatchingGame cardAtIndex:index];

  [cardView setupWithSetCard:setCard];
  return cardView;
}


@end

NS_ASSUME_NONNULL_END
