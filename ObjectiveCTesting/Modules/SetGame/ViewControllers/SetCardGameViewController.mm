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
    LogDebug(@"CardView in getCardForView is not of kind SetCardView.");
    return nil;
  }
  if (![self.cardMatchingGame isKindOfClass:[SetCardMatchingGame class]]) {
    LogDebug(@"CardMatchingGame in getCardForView is not of kind SetCardMatchingGame.");
    return nil;
  }

  auto setCardView = (SetCardView *)cardView;
  auto setCardMatchingGame = (SetCardMatchingGame *)self.cardMatchingGame;
  auto card = [setCardMatchingGame getCardForShape:setCardView.shape
                                          andColor:setCardView.color
                                           andFill:setCardView.fill
                                 andNumberOfShapes:setCardView.numberOfShapes];
  return card;
}

- (CardView *)drawCardAndCreateView {
  auto cardView = [[SetCardView alloc] init];
  auto setCard = (SetCard *)[self.cardMatchingGame drawNextCard];
  [cardView setupWithSetCard:setCard];
  return cardView;
}

@end

NS_ASSUME_NONNULL_END
