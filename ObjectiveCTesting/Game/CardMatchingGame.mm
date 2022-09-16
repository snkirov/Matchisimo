// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.


#import "CardMatchingGame.h"
#import "Deck.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSMutableAttributedString * lastMoveDescriptionMutable;
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

- (NSAttributedString *)lastMoveDescription {
  return [self.lastMoveDescriptionMutable copy];
}

static const int mismatchPenalty = 2;
static const int guessPenalty = 1;
static const int matchMultiplier = 4;

- (void)chooseCardAtIndex:(NSUInteger)index {
  Card *card = [self cardAtIndex:index];
  
  if (card.isMatched) {
    return;
  }
  
  if (card.isChosen) {
    _lastMoveDescriptionMutable = [[NSMutableAttributedString alloc] initWithString:@""];
    card.isChosen = NO;
    return;
  }
  
  _lastMoveDescriptionMutable = [card.attributedContents mutableCopy];
  NSMutableArray<Card *> *chosenCards = [NSMutableArray<Card *> array];
  
  for (Card *otherCard in self.cards) {
    if (otherCard.isChosen && !otherCard.isMatched) {
      
      [chosenCards addObject:otherCard];
      [_lastMoveDescriptionMutable appendAttributedString:otherCard.attributedContents];
      
      if (chosenCards.count == _matchCount - 1) {
        [self evaluateMatch:card withCards:chosenCards];
      }
    }
  }
  
  _score -= guessPenalty;
  card.isChosen = TRUE;
}

- (void) evaluateMatch: (Card *)card withCards: (NSArray<Card *> *)chosenCards {
  int matchScore = [card match:chosenCards];
  if (matchScore) {
    int pointsForThisRound = matchScore * matchMultiplier;
    [_lastMoveDescriptionMutable appendAttributedString: [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" matched for %d points.", pointsForThisRound]]];
    _score += pointsForThisRound;
    card.isMatched = TRUE;
    for (Card * chosenCard in chosenCards) {
      chosenCard.isMatched = true;
    }
  } else {
    [_lastMoveDescriptionMutable appendAttributedString: [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %d point penalty!", mismatchPenalty]]];
    _score -= mismatchPenalty;
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
