//
//  Deck.m
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray<Card *> *cards;
@end

@implementation Deck

- (NSMutableArray<Card *> *) cards {

  if (!_cards) {
    _cards = [NSMutableArray<Card *> array];
  }
  return _cards;
}

- (void)addCard: (Card *)card atTheTop: (BOOL)atTop {
  if (atTop) {
    [self.cards addObject:card];
  } else {
    [self.cards insertObject:card atIndex:0];
  }
}

- (void)addCard: (Card *)card {
  [self addCard: card atTheTop: FALSE];
}

- (Card *)drawRandomCard {

  Card *randomCard = nil;

  if ([self.cards count]) {
    unsigned index = arc4random() % [self.cards count];
    randomCard = self.cards[index];
    [self.cards removeObjectAtIndex: index];
  }

  return randomCard;
}

@end
