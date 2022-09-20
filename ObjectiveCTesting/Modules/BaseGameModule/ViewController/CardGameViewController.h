//
//  CardGameViewController.h
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

- (Deck *)createDeck; // abstract

// Has Default Implementation
- (void)updateTitleOfButton:(UIButton *)cardButton forCard:(Card *)card;

@end

