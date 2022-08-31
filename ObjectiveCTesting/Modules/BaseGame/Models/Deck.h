//
//  Deck.h
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//


#ifndef Deck_h
#define Deck_h

@class Card;

@interface Deck : NSObject

- (Card *)drawRandomCard;
- (void)addCard:(Card *)card;

@end


#endif /* Deck_h */