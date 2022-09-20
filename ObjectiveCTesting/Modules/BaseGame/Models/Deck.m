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
    self.cards = [NSMutableArray<Card *> array];
  }
  return self;
}

- (Card *)drawRandomCard {

  if (![self.cards count]) {
    LogDebug(@"Deck is empty, cannot drawRandomCard.");
    return nil;
  }

  unsigned index = arc4random() % [self.cards count];
  Card *randomCard = self.cards[index];
  [self.cards removeObjectAtIndex:index];

  return randomCard;
}

- (void)addCard:(Card *)card {
  [self.cards addObject:card];
}

- (BOOL)isEmpty {
  return self.cards.count == 0;
}

@end
