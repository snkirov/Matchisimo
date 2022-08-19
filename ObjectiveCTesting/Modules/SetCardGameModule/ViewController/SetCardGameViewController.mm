// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardGameViewController

- (Deck *)createDeck {
  return [[SetCardDeck alloc] init];
}

@end

NS_ASSUME_NONNULL_END
