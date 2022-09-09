// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardGameViewController.h"
#import "PlayingCardView.h"
#import "SetCardView.h"
#import "SetCardUtil.h"

// TODO: REMOVE
#import "DeckFactory.h"
#import "Deck.h"
#import "Card.h"
#import "SetCardMatchingService.h"
#import "SetCard.h"
#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardGameViewController()
@property (weak, nonatomic) IBOutlet PlayingCardView *cardView;
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@end

@implementation PlayingCardGameViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  [_cardView setupWithPlayingCard:[[PlayingCard alloc] initWithSuit:@"♥️" withRank:10]];
  _cardView.faceUp = true;
  auto setCard = [[SetCard alloc] initWithShape:CARD_Shape::Oval
                                      withColor:CARD_Color::Red
                                       withFill:CARD_Fill::Striped
                             withNumberOfShapes:CARD_NumberOfShapes::Three];
  [_setCardView setupWithSetCard:setCard];

  auto deck = [DeckFactory generateDeckWithSetCards];
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
