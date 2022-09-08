// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardGameViewController.h"
#import "PlayingCardView.h"
#import "SetCardView.h"
#import "SetCardUtil.h"

// TODO: REMOVE
#import "SetCardDeck.h"
#import "Card.h"
#import "SetCardMatchingService.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardGameViewController()
@property (weak, nonatomic) IBOutlet PlayingCardView *cardView;
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@end

@implementation PlayingCardGameViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  _cardView.suit = @"♥️";
  _cardView.rank = 10;
  _cardView.faceUp = true;
  _setCardView.shape = (CARD_Shape)1;
  _setCardView.color = (CARD_Color)1;
  _setCardView.fill = (CARD_Fill)1;
  _setCardView.numberOfShapes = (CARD_NumberOfShapes)1;


  auto deck = [[SetCardDeck alloc] init];
  auto card1 = [deck drawRandomCard];
  auto card2 = [deck drawRandomCard];
  auto card3 = [deck drawRandomCard];
  LogDebug(@"%@\n%@\n%@\n", card1.contents, card2.contents, card3.contents);
  auto matchingService = [[SetCardMatchingService alloc] init];
  auto result = [matchingService matchCard:card1 withOtherCards:[NSArray arrayWithObjects: card1, card1, nil]];
  LogDebug(@"Matching score: %d", result);
}

@end

NS_ASSUME_NONNULL_END
