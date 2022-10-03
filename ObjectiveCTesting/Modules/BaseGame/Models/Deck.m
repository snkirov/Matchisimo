//
//  Deck.m
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

#import "Deck.h"

@interface Deck()

@property (strong, nonatomic) NSMutableArray<id <CardProtocol>> *cards;

@end

@implementation Deck

- (instancetype)init {
  if (self = [super init]) {
    self.cards = [NSMutableArray<id <CardProtocol>> array];
  }
  return self;
}

- (nullable id <CardProtocol>)drawRandomCard {
  if ([self isEmpty]) {
    LogDebug(@"Deck is empty, cannot drawRandomCard.");
    return nil;
  }

  unsigned index = arc4random() % [self.cards count];
  id <CardProtocol> randomCard = self.cards[index];
  [self.cards removeObjectAtIndex:index];

  return randomCard;
}

- (void)addCard:(id <CardProtocol>)card {
  [self.cards addObject:card];
}

- (BOOL)isEmpty {
  return self.cards.count == 0;
}

@end
