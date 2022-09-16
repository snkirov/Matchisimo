// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.


#import "Grid.h"
#import "DeckFactory.h"
#import "BaseGameViewController+Protected.h"
#import "SetCard.h"
#import "SetCardGameViewController.h"
#import "SetCardMatchingGame.h"
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

- (CardView *)generateCardView {
  auto cardView = [[SetCardView alloc] init];
  auto setCard = (SetCard *)[self.cardMatchingGame drawNextCard];
  [cardView setupWithSetCard:setCard];
  return cardView;
}

@end

NS_ASSUME_NONNULL_END
