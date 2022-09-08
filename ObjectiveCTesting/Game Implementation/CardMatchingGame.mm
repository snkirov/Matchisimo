// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import "Deck.h"
#import "Card.h"
#import "CardMatchingServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray<Card *> *cards;
@property (nonatomic) NSInteger matchCount;
@end

@implementation CardMatchingGame

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
  return [self initWithCardCount:count usingDeck:deck withMatchCount:2];
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger) matchCount {
  if (self = [super init]) {
    Deck *deck = [[PlayingCardDeck alloc] init];
    _cards = [[NSMutableArray<Card *> alloc] init];
    _matchCount = matchCount;
    for(int i = 0; i < count; i ++) {
      Card* card = [deck drawRandomCard];
      if (card) {
        [_cards addObject:card];
      } else {
        _cards = nil;
        self = nil;
        return self;
      }

    }
  }
  return self;
}

static const int MISMATCH_PENALTY = 2;
static const int GUESS_PENALTY = 1;

- (void)chooseCardAtIndex:(NSUInteger)index {
  Card *card = [self cardAtIndex:index];

  if (card.isMatched) {
    return;
  }

  if (card.isChosen) {
    card.isChosen = NO;
    return;
  }

  NSMutableArray<Card *> *chosenCards = [NSMutableArray<Card *> array];
  long extraCardsRequiredForMatch = _matchCount - 1;

  for (Card *otherCard in self.cards) {
    if (otherCard.isChosen && !otherCard.isMatched) {

      [chosenCards addObject:otherCard];
      extraCardsRequiredForMatch--;

      if (extraCardsRequiredForMatch == 0) {
        [self evaluateMatch: card withCards: chosenCards];
      }
    }
  }

  _score -= GUESS_PENALTY;
  card.isChosen = TRUE;
}

- (void) evaluateMatch: (Card *)card withCards: (NSArray<Card *> *)chosenCards {
  // TODO: Discuss with Cam
  int matchScore = [self.matchingService matchCard:card withOtherCards:chosenCards];
  if (matchScore) {
    int pointsForThisRound = matchScore * 4;
    _score += pointsForThisRound;
    card.isMatched = TRUE;
    for (Card * chosenCard in chosenCards) {
      chosenCard.isMatched = true;
    }
  } else {
    _score -= MISMATCH_PENALTY;
    for (Card * chosenCard in chosenCards) {
      chosenCard.isChosen = false;
    }
  }
}

- (Card *)cardAtIndex:(NSUInteger)index {
  Card * card = nil;
  if (index >= 0 && index < _cards.count) {
    card = _cards[index];
  }
  return card;
}

@end

NS_ASSUME_NONNULL_END
