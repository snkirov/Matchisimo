// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardProtocol.h"
#import "CardMatchingGame.h"
#import "CardMatchingGame+Protected.h"
#import "CardMatchingServiceProtocol.h"
#import "Deck.h"

NS_ASSUME_NONNULL_BEGIN

@class CardView;

@interface CardMatchingGame()

@property (nonatomic, readwrite) Deck *deckToBeDrawn;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic) NSInteger matchCount;

@end

@implementation CardMatchingGame

- (instancetype)initUsingDeck:(Deck *)deck {
  [NSException raise:@"Init Using Deck should be overwritten."
              format:@"Init Using Deck is an abstract method, which should be overwritten by all children."];
  return nil;
}

- (instancetype)initUsingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger) matchCount {
  if (self = [super init]) {
    self.cardsInPlay = [[NSMutableArray<id <CardProtocol>> alloc] init];
    self.matchCount = matchCount;
    self.deckToBeDrawn = deck;
  }
  return self;
}

static const int correctGuessMultiplier = 4;
static const int mismatchPenalty = 2;
static const int guessPenalty = 1;

- (void)removeCard:(id <CardProtocol>)card {
  [_cardsInPlay removeObject:card];
}

- (void)chooseCard:(id <CardProtocol>)card {

  if (card.isMatched) {
    return;
  }

  if (card.isSelected) {
    card.isSelected = NO;
    return;
  }

  [self checkForMatchWithCard:card];

  _score -= guessPenalty;
  card.isSelected = TRUE;
}

- (void)checkForMatchWithCard:(id <CardProtocol>)card {
  NSMutableArray<id <CardProtocol>> *chosenCards = [NSMutableArray<id <CardProtocol>> array];
  auto extraCardsRequiredForMatch = _matchCount - 1;

  for (id <CardProtocol> otherCard in self.cardsInPlay) {
    if (otherCard.isSelected && !otherCard.isMatched) {

      [chosenCards addObject:otherCard];

      if (chosenCards.count == extraCardsRequiredForMatch) {
        NSArray<id <CardProtocol>> *immutableChosenCards = [chosenCards copy];
        [self evaluateMatch:card withCards:immutableChosenCards];
        return;
      }
    }
  }
}

- (void)evaluateMatch:(id <CardProtocol>)card withCards:(NSArray<id <CardProtocol>> *)chosenCards {
  auto matchScore = [self.matchingService matchCard:card withOtherCards:chosenCards];
  if (matchScore) {
    auto pointsForThisRound = matchScore * correctGuessMultiplier;
    _score += pointsForThisRound;
    for (id <CardProtocol> chosenCard in [chosenCards arrayByAddingObject:card]) {
      chosenCard.isMatched = TRUE;
    }
  } else {
    _score -= mismatchPenalty;
    for (id <CardProtocol> chosenCard in chosenCards) {
      chosenCard.isSelected = FALSE;
    }
  }
}

- (nullable id <CardProtocol>)drawNextCard {
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
