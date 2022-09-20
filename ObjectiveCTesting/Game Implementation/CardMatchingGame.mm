// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "Card.h"
#import "CardMatchingGame.h"
#import "CardMatchingGame+Protected.h"
#import "CardMatchingServiceProtocol.h"
#import "Deck.h"

NS_ASSUME_NONNULL_BEGIN

@class CardView;

@interface CardMatchingGame()
@property (nonatomic, readwrite)Deck *deckToBeDrawn;
@property (nonatomic, readwrite)NSInteger score;
@property (nonatomic)NSInteger matchCount;
@end

@implementation CardMatchingGame

- (instancetype)initUsingDeck:(Deck *)deck {
  return [self initUsingDeck:deck withMatchCount:2];
}

- (instancetype)initUsingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger) matchCount {
  if (self = [super init]) {
    self.cardsInPlay = [[NSMutableArray<Card *> alloc] init];
    self.matchCount = matchCount;
    self.deckToBeDrawn = deck;
  }
  return self;
}

static const int MISMATCH_PENALTY = 2;
static const int GUESS_PENALTY = 1;

- (void)removeCard:(Card *)card {
  [_cardsInPlay removeObject:card];
}

- (void)chooseCard:(Card *)card {

  if (card.isMatched) {
    return;
  }

  if (card.isChosen) {
    card.isChosen = NO;
    return;
  }

  [self checkForMatchWithCard:card];

  _score -= GUESS_PENALTY;
  card.isChosen = TRUE;
}

- (void)checkForMatchWithCard:(Card *)card {
  NSMutableArray<Card *> *chosenCards = [NSMutableArray<Card *> array];
  auto extraCardsRequiredForMatch = _matchCount - 1;

  for (Card *otherCard in self.cardsInPlay) {
    if (otherCard.isChosen && !otherCard.isMatched) {

      [chosenCards addObject:otherCard];

      if (chosenCards.count == extraCardsRequiredForMatch) {
        NSArray *immutableChosenCards = [chosenCards copy];
        [self evaluateMatch:card withCards:immutableChosenCards];
        return;
      }
    }
  }
}

- (void)evaluateMatch:(Card *)card withCards:(NSArray<Card *> *)chosenCards {
  auto matchScore = [self.matchingService matchCard:card withOtherCards:chosenCards];
  if (matchScore) {
    auto pointsForThisRound = matchScore * 4;
    _score += pointsForThisRound;
    card.isMatched = TRUE;
    for (Card * chosenCard in chosenCards) {
      chosenCard.isMatched = TRUE;
    }
  } else {
    _score -= MISMATCH_PENALTY;
    for (Card * chosenCard in chosenCards) {
      chosenCard.isChosen = FALSE;
    }
  }
}

- (Card *)drawNextCard {
  if (!self.canDrawMore) {
    LogDebug(@"Can't draw next card.");
    return nil;
  }
  auto nextCard = [self.deckToBeDrawn drawRandomCard];
  [self.cardsInPlay addObject:nextCard];
  return nextCard;
}

- (BOOL)canDrawMore {
  return ![self.deckToBeDrawn isEmpty];
}

@end

NS_ASSUME_NONNULL_END
