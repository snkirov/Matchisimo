// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardGameViewController

- (Deck *)createDeck {
  return [[SetCardDeck alloc] init];
}

- (void)updateTitleOfButton:(UIButton *)cardButton forCard:(Card *)card {
  if (card.isChosen) {
    [cardButton setAttributedTitle:((SetCard *)card).attributedContents forState:UIControlStateNormal];
  } else {
    NSAttributedString *emptyAttributedString = [[NSAttributedString alloc] initWithString:@""];
    [cardButton setAttributedTitle: emptyAttributedString forState: UIControlStateNormal];
  }
}

@end

NS_ASSUME_NONNULL_END
