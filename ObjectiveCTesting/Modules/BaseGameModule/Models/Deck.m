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

- (void)addCardAtTheTop: (Card *)card {
  [self.cards addObject:card];
}

- (void)addCardAtTheBottom: (Card *)card {
  [self.cards insertObject:card atIndex:0];
}

- (Card *)drawRandomCard {

  if (![self.cards count]) {
    return nil;
  }

  unsigned index = arc4random() % [self.cards count];
  Card *randomCard = self.cards[index];
  [self.cards removeObjectAtIndex: index];
  
  return randomCard;
}

@end
