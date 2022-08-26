//
//  Deck.m
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

#import "Deck.h"

@implementation Deck

- (instancetype) init {
  if (self = [super init]) {
    _cards = [NSMutableArray<Card *> array];
  }
  return self;
}

@end
