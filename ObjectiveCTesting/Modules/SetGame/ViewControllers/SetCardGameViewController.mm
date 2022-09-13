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

- (Card *)getCardForView:(CardView *)cardView {
  if (![cardView isKindOfClass:[SetCardView class]]) {
    return nil;
  }
  auto setCardView = (SetCardView *)cardView;
  auto card = [[SetCard alloc] initWithShape:setCardView.shape
                                   withColor:setCardView.color
                                    withFill:setCardView.fill
                          withNumberOfShapes:setCardView.numberOfShapes];
  return card;
}

- (CardView *)addCardView {
  auto cardView = [[SetCardView alloc] init];
  auto setCard = (SetCard *)[self.cardMatchingGame drawNextCard];
  [cardView setupWithSetCard:setCard];
  return cardView;
}

- (CardView *)addCardViewWithFrame:(CGRect)frame {
  auto cardView = [[SetCardView alloc] init];

  cardView.frame = CGRectMake(self.view.center.x, self.view.center.y / 2, 0, 0);
  [UIView animateWithDuration:1.0 animations:^{
    cardView.frame = frame;
  }];

  auto setCard = (SetCard *)[self.cardMatchingGame drawNextCard];
  [cardView setupWithSetCard:setCard];
  return cardView;
}

@end

NS_ASSUME_NONNULL_END
