// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardMatchingGame+Protected.h"
#import "SetCard.h"
#import "SetCardMatchingGame.h"
#import "SetCardMatchingService.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardMatchingGame()

@property (nonatomic, readwrite) id <CardMatchingServiceProtocol> matchingService;

@end

@implementation SetCardMatchingGame

@synthesize matchingService = _matchingService;

- (instancetype)initUsingDeck:(Deck *)deck {
  return [self initUsingDeck:deck withMatchCount:3];
}

- (instancetype)initUsingDeck:(Deck *)deck
               withMatchCount:(NSUInteger) matchCount {
  if (self = [super initUsingDeck:deck withMatchCount:matchCount]) {
    self.matchingService = [[SetCardMatchingService alloc] init];
  }
  return self;
}

- (SetCard *)getCardForShape:(CARD_Shape)shape
                    andColor:(CARD_Color)color
                     andFill:(CARD_Fill)fill
           andNumberOfShapes:(CARD_NumberOfShapes)numberOfShapes {
  for (Card *card in self.cardsInPlay) {
    if (![card isKindOfClass:[SetCard class]]) {
      LogDebug(@"Card in getCardForShape is not of kind SetCard.");
      continue;
    }
    auto setCard = (SetCard *)card;
    if (setCard.shape == shape
        && setCard.color == color
        && setCard.fill == fill
        && setCard.numberOfShapes == numberOfShapes) {
      return setCard;
    }
  }
  LogDebug(@"No SetCard with provided  shape: %u, color: %u, fill: %u and numberOfShapes: %u present in cards array.", shape, color, fill, numberOfShapes);
  return nil;
}

@end

NS_ASSUME_NONNULL_END
