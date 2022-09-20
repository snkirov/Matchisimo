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
@property (nonatomic, readwrite)NSInteger score;
@property (nonatomic)NSInteger matchCount;
@property (nonatomic)NSInteger indexOfNextCardToBeDrawn;
@end

@implementation CardMatchingGame

- (instancetype)initUsingDeck:(Deck *)deck {
  return [self initUsingDeck:deck withMatchCount:2];
}

- (instancetype)initUsingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger) matchCount {
  if (self = [super init]) {
    _cards = [[NSMutableArray<Card *> alloc] init];
    _matchCount = matchCount;
    _indexOfNextCardToBeDrawn = 0;
    auto deckSize = [deck deckSize];
    for(int i = 0; i < deckSize; i ++) {
      Card* card = [deck drawRandomCard];
      if (!card) {
        LogDebug(@"Can't initialise CardMatchingGame with a nil card. Deck drawRandomCard returned nil for i: %u.", i);
        // Not sure if this is necessary. Just return nil could work fine as well.
        _cards = nil;
        return nil;
      }
      [_cards addObject:card];
    }
  }
  return self;
}

static const int MISMATCH_PENALTY = 2;
static const int GUESS_PENALTY = 1;

- (void)removeCard:(Card *)card {
  [_cards removeObject:card];
  _indexOfNextCardToBeDrawn--;
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

  for (Card *otherCard in self.cards) {
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
  auto nextCard = _cards[_indexOfNextCardToBeDrawn];
  _indexOfNextCardToBeDrawn++;
  return nextCard;
}

- (BOOL)canDrawMore {
  return _indexOfNextCardToBeDrawn < _cards.count;
}

@end

NS_ASSUME_NONNULL_END
