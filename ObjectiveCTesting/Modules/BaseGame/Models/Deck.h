//
//  Deck.h
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//


#ifndef Deck_h
#define Deck_h

NS_ASSUME_NONNULL_BEGIN

@protocol CardProtocol;

/// This class defines a simple deck data structure, which manipulates an array of cards.
/// Cards can be added to or drawn from the deck.
@interface Deck : NSObject

/// Returns a random `Card` from the deck.
/// Returns nil if the deck is empty.
- (nullable id <CardProtocol>)drawRandomCard;
/// Adds a card to the deck.
- (void)addCard:(id <CardProtocol>)card;
/// Returns whether the deck is empty.
- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END

#endif /* Deck_h */
