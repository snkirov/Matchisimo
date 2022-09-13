// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardMatchingGame.h"
#import "Deck.h"
#import "Card.h"
#import "CardMatchingServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CardView;

@interface CardMatchingGame()
@property (nonatomic, readwrite)NSInteger score;
@property (nonatomic, strong)NSMutableArray<Card *> *cards;
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
      if (card) {
        [_cards addObject:card];
      } else {
        _cards = nil;
        return nil;
      }
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

- (void) evaluateMatch:(Card *)card withCards:(NSArray<Card *> *)chosenCards {
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

- (Card *)getCardPointerForCard:(Card *)card {
  for (Card *otherCard in _cards) {
    if ([self compareCard:card withCard:otherCard]) {
      return otherCard;
    }
  }
  return nil;
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

// MARK: - Abstract

- (BOOL)compareCard:(Card *)card withCard:(Card *)otherCard {
  [NSException raise:@"CompareCard should be overwritten."
              format:@"CompareCard is an abstract method, which should be overriden by all children."];
  return FALSE;
}

@end

NS_ASSUME_NONNULL_END
