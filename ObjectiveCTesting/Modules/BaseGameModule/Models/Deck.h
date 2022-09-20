//
//  Deck.h
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

#import <Foundation/Foundation.h>
#import "Card.h"

#ifndef Deck_h
#define Deck_h

@interface Deck : NSObject

- (void)addCardAtTheTop: (Card *)card;
- (void)addCardAtTheBottom: (Card *)card;

- (Card *)drawRandomCard;

@end


#endif /* Deck_h */
