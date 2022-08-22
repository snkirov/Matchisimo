// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.


#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import "Deck.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSMutableAttributedString * lastMoveDescription;
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
//  NSLog(@"We chose card %@", card.contents);

  if (card.isMatched) {
    return;
  }

  if (card.isChosen) {
    _lastMoveDescription = [[NSMutableAttributedString alloc] initWithString:@""];
    card.isChosen = NO;
    return;
  }

  _lastMoveDescription = [[NSMutableAttributedString alloc] initWithAttributedString:[card.attributedContents copy]];
  NSMutableArray<Card *> *chosenCards = [NSMutableArray<Card *> array];
  long extraCardsRequiredForMatch = _matchCount - 1;

  for (Card *otherCard in self.cards) {
    if (otherCard.isChosen && !otherCard.isMatched) {

      [chosenCards addObject:otherCard];
      auto attributedString = (NSAttributedString *)otherCard.attributedContents;
      [_lastMoveDescription appendAttributedString: attributedString];
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
  int matchScore = [card match:chosenCards];
  if (matchScore) {
    int pointsForThisRound = matchScore * 4;
    [_lastMoveDescription appendAttributedString: [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" matched for %d points.", pointsForThisRound]]];
    _score += pointsForThisRound;
    card.isMatched = TRUE;
    for (Card * chosenCard in chosenCards) {
      chosenCard.isMatched = true;
    }
  } else {
    [_lastMoveDescription appendAttributedString: [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %d point penalty!", MISMATCH_PENALTY]]];
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
