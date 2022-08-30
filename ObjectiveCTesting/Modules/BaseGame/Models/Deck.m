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

- (instancetype) init {
  if (self = [super init]) {
    _cards = [NSMutableArray<Card *> array];
  }
  return self;
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

- (void)addCard:(Card *)card {
  [self.cards addObject:card];
}

@end
